import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/user_info.dart';

class UserController extends GetxController {
  MyUserInfo _currentUser = MyUserInfo.empty();

  MyUserInfo get currentUser => _currentUser;

  void setCurrentUser(MyUserInfo user) {
    _currentUser = user;
    update();
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

  void addNewFCM(String fcm) {
    List<String> list = currentUser.fcm;
    if (!list.contains(fcm)) {
      list.add(fcm);
    }
    setCurrentUser(
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
}
