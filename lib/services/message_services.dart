import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/message_info.dart';

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

  Future<bool> sendMessage(MessageInfo message) async {
    try {
      await _instance.collection("messages").add(message.toMap());
      FirebaseMessaging.instance.sendMessage(
        to: message.receiverId,
        data: message.toMessage(),
      );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "sendMessage", data: error);
      return false;
    }
  }
}
