import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../models/models.dart';
import '../services/contact_services.dart';
import '../services/messages_db_helper.dart';
import 'user_controller.dart';

class AuthController extends GetxController {
  String _countryCode = "";
  String _phoneNumber = "";
  int? _resendToken;
  bool _smsReceived = false;
  String _verificationID = "";

  bool get smsReceived => _smsReceived;

  String get phoneNumber => _countryCode + _phoneNumber;

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

  Future<void> saveAuthData(User user) async {
    await Get.find<UserController>().setCurrentUser(
      Get.find<UserController>().currentUser.copyWith(
            phoneNumber: _phoneNumber,
            id: user.uid,
            countryCode: _countryCode,
          ),
    );
    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(Get.find<UserController>().currentUser.id)
        .get();

    if (response.data() != null) {
      await Get.find<UserController>().setCurrentUser(
          MyUserInfo.fromFirebase(response.data()!, response.id));
    }

    String fcm = await FirebaseMessaging.instance.getToken() ?? "Not available";
    String deviceId = await PlatformDeviceId.getDeviceId ?? "";
    await FcmInfo(
      createdAt: DateTime.now(),
      deviceId: deviceId,
      fcm: fcm,
      userId: Get.find<UserController>().currentUser.id,
    ).upload();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Get.find<UserController>().currentUser.id)
        .set(
          Get.find<UserController>().currentUser.toMap(),
          SetOptions(merge: true),
        );
    await _config();
  }

  Future<bool> verifyPhone(String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID, smsCode: code);
    // Sign the user in (or link) with the credential
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await saveAuthData(user.user!);
    return true;
  }

  Future<void> phoneAuth(String phoneCode, String phoneNumber) async {
    _countryCode = phoneCode;

    for (int i = 0; i < phoneCode.length; i++) {
      if (phoneNumber.startsWith(phoneCode[i])) {
        phoneNumber = phoneNumber.replaceFirst(phoneCode[i], "");
      }
    }
    _phoneNumber = phoneNumber;
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      print("starting the phone auth");
      await auth.verifyPhoneNumber(
        phoneNumber: _countryCode + _phoneNumber,
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
          print("sms sent");
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(minutes: 2),
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
        phoneNumber: phoneNumber,
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
        timeout: const Duration(minutes: 2),
      );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "getCountries", data: error);
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    } else {
      await Get.find<UserController>().getUser();
      await _config();
      return true;
    }
  }

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("AUTH_SERVICES $functionName $variableName: $data ");
  }

  Future<void> _config() async {
    await MessagesDBHelper().initialize();
    await ContactServices().canGetContacts().then((value) {
      if (value) {
        ContactServices().getContacts();
      } else {
        ContactServices().getContactsPermission().then((value) {
          if (value) {
            ContactServices().getContacts();
          }
        });
      }
    });
    FirebaseFirestore.instance
        .collection("messages")
        .where("receiver_id",
            isEqualTo: Get.find<UserController>().currentUser.id)
        .get()
        .asStream()
        .listen(
      (message) async {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in message.docs) {
          await MessagesDBHelper()
              .insertIfAbsent(MessageInfo.fromFirebase(doc.data(), doc.id));
          await FirebaseFirestore.instance
              .collection("messages")
              .doc(doc.id)
              .delete();
        }
      },
    );
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await MessagesDBHelper().resetDB();
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "signOut", data: error);
      return false;
    }
  }
}
