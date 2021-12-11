import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  String _phoneNumber = "";
  int? _resendToken;
  String _verificationID = "";
  bool _smsReceived = false;

  bool get smsReceived => _smsReceived;

  String get phoneNumber => _phoneNumber;

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("AUTH_SERVICES $functionName $variableName: $data ");
  }

  Future<List<CountryInfo>> getCountries() async {
    try {
      List<CountryInfo> countries = [];
      //getting the json data from the assets
      String jsonStringValues =
          await rootBundle.loadString("assets/util/country_info.json");

      //decoding the json data
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      mappedJson.forEach((key, value) {
        countries.add(CountryInfo.fromJSON(value));
      });
      countries.sort((first, second) => first.name.compareTo(second.name));
      return countries..removeWhere((element) => element.phoneCode == "+");
    } catch (error) {
      _echo(variableName: "error", functionName: "phoneAuth", data: error);
      rethrow;
    }
  }

  Future<bool> verifyPhone(String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID, smsCode: code);
    // Sign the user in (or link) with the credential
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    Get.find<UserController>().setCurrentUser(
      Get.find<UserController>().currentUser.copyWith(
            phoneNumber: user.user!.phoneNumber,
            id: user.user!.uid,
          ),
    );
    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(Get.find<UserController>().currentUser.id)
        .get();

    if (response.data() != null) {
      Get.find<UserController>().setCurrentUser(
          MyUserInfo.fromFirebase(response.data()!, response.id));
    }

    String fcm = await FirebaseMessaging.instance.getToken() ?? "Not available";
    Get.find<UserController>().addNewFCM(fcm);
    FirebaseFirestore.instance
        .collection("users")
        .doc(Get.find<UserController>().currentUser.id)
        .set(
          Get.find<UserController>().currentUser.toMap(),
          SetOptions(merge: true),
        );
    return true;
  }

  Future<void> phoneAuth(String phoneCode, String phoneNumber) async {
    _phoneNumber = phoneCode + phoneNumber;
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            throw ('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationID = verificationId;
          _resendToken = resendToken;
          _smsReceived = true;
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (error) {
      _echo(variableName: "error", functionName: "getCountries", data: error);
      rethrow;
    }
  }

  Future<bool> resendCode() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        forceResendingToken: _resendToken,
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            throw ('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationID = _verificationID;
          _resendToken = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "getCountries", data: error);
      rethrow;
    }
  }
}
