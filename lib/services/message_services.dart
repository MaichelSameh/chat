import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../models/message_info.dart';
import 'messages_db_helper.dart';

class MessageServices {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("MESSAGE_SERVICES $functionName $variableName: $data ");
  }

  Future<bool> sendMessageNotification(MessageInfo message) async {
    return true;
  }

  Future<bool> sendTextMessage(MessageInfo message) async {
    try {
      DocumentReference<Map<String, dynamic>> ref =
          await _instance.collection("messages").add(message.toMap());
      await ref.get().then(
            (value) => MessagesDBHelper().insertMessage(
              MessageInfo.fromFirebase(value.data()!, value.id),
            ),
          );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "sendMessage", data: error);
      return false;
    }
  }

  Future<bool> sendFileMessage(MessageInfo message, File file) async {
    try {
      String messageId = "";
      DocumentReference<Map<String, dynamic>> ref =
          await _instance.collection("messages").add(message.toMap());
      DocumentSnapshot<Map<String, dynamic>> res = await ref.get();
      messageId = res.id;
      String url = "";
      TaskSnapshot linkRef = await FirebaseStorage.instance
          .ref(
              "/messages/${messageId + ' ' + DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}")
          .putFile(file);
      url = await linkRef.ref.getDownloadURL();
      await _instance
          .collection("messages")
          .doc(messageId)
          .set({"media_link": url}, SetOptions(merge: true));

      MessagesDBHelper().insertMessage(
        MessageInfo.fromFirebase(
            message.copyWith(mediaLink: url).toMap(), messageId),
      );
      return true;
    } catch (error) {
      _echo(
          variableName: "error", functionName: "sendFileMessage", data: error);
      return false;
    }
  }

  Future<bool> sendImageMessage(MessageInfo message, File file) async {
    try {
      String messageId = "";
      DocumentReference<Map<String, dynamic>> ref =
          await _instance.collection("messages").add(message.toMap());
      DocumentSnapshot<Map<String, dynamic>> res = await ref.get();
      messageId = res.id;
      String url = "";
      TaskSnapshot linkRef = await FirebaseStorage.instance
          .ref(
              "/messages/${messageId + ' ' + DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())}")
          .putFile(file);
      url = await linkRef.ref.getDownloadURL();
      await _instance
          .collection("messages")
          .doc(messageId)
          .set({"media_link": url}, SetOptions(merge: true));

      MessagesDBHelper().insertMessage(
        MessageInfo.fromFirebase(
            message.copyWith(mediaLink: url).toMap(), messageId),
      );
      return true;
    } catch (error) {
      _echo(
          variableName: "error", functionName: "sendImageMessage", data: error);
      return false;
    }
  }
}
