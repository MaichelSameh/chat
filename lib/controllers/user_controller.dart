import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_info.dart';

class UserController extends GetxController {
  MyUserInfo _currentUser = MyUserInfo.empty();

  MyUserInfo get currentUser => _currentUser;

  Future<void> setCurrentUser(MyUserInfo user) async {
    _currentUser = user;
    update();
    await _saveUser();
  }

  Future<void> updateUserPhoto(File photo) async {
    TaskSnapshot ref = await FirebaseStorage.instance
        .ref("/users/${Get.find<UserController>().currentUser.id}")
        .putFile(photo);
    String link = await ref.ref.getDownloadURL();
    setCurrentUser(currentUser.copyWith(profileURL: link));
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.id)
        .set({"profile_url": link}, SetOptions(merge: true));
  }

  Future<void> addNewFCM(String fcm) async {
    List<String> list = currentUser.fcm;
    if (!list.contains(fcm)) {
      list.add(fcm);
    }
    await setCurrentUser(
      currentUser.copyWith(fcm: list),
    );
  }

  Future<void> updateMyInfo(String name, String bio) async {
    setCurrentUser(
      currentUser.copyWith(bio: bio, name: name),
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.id)
        .set({"bio": bio, "name": name}, SetOptions(merge: true));
  }

  Future<MyUserInfo?> searchUserByPhone(String phoneNumber) async {
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection("users")
        .where("phone", isEqualTo: phoneNumber)
        .get();
    return res.docs.isNotEmpty
        ? MyUserInfo.fromFirebase(res.docs.first.data(), res.docs.first.id)
        : null;
  }

  Future<void> _saveUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> map = currentUser.toMap();
    map.putIfAbsent("id", () => currentUser.id);
    await pref.setString("user", json.encode(map));
  }

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> user = json.decode(pref.getString("user")!);
    await setCurrentUser(MyUserInfo.fromFirebase(user, user["id"]));
  }
}
