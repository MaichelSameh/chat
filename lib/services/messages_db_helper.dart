import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import '../config/db_config.dart';
import '../controllers/user_controller.dart';
import '../models/message_info.dart';

class MessagesDBHelper {
  static Database? _db;

  Future<Database> initialize() async {
    if (_db != null) {
      return _db!;
    } else {
      Directory dir = await path_provider.getApplicationDocumentsDirectory();
      Database db = await openDatabase(
        dir.path + DBConfig.messages_table_name,
        version: 1,
        onCreate: (db, version) async {
          await createDB(db);
        },
      );
      _db = db;
      return _db!;
    }
  }

  Future<void> createDB(Database db) async {
    db.execute('''
      CREATE TABLE ${DBConfig.messages_table_name} (
        created_at TEXT NOT NULL,
        media_link TEXT NOT NULL,
        message TEXT NOT NULL,
        receiver_id TEXT NOT NULL,
        receiver_type_id TEXT NOT NULL,
        sender_id TEXT NOT NULL,
        file_name TEXT NOT NULL,
        id TEXT NOT NULL PRIMARY KEY,
        media_type TEXT NOT NULL
      );
    ''');
  }

  Future<bool> insertMessage(MessageInfo message) async {
    try {
      Database db = await initialize();
      await db.insert(DBConfig.messages_table_name, message.toLocalDB());
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "insertMessage", data: error);
      return false;
    }
  }

  Future<bool> insertIfAbsent(MessageInfo message) async {
    Database db = await initialize();
    List<Map<String, dynamic>> list = await db
        .query(DBConfig.messages_table_name, where: "id = '${message.id}'");
    if (list.isEmpty) {
      return await insertMessage(message);
    } else {
      return false;
    }
  }

  Future<bool> deleteMessage(String id) async {
    try {
      Database db = await initialize();
      await db.update(
        DBConfig.messages_table_name,
        {
          "id": id,
          "media_link": "",
          "message": "This message was deleted",
        },
        where: "id = '$id'",
      );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "deleteMessage", data: error);
      return false;
    }
  }

  Future<List<MessageInfo>> getMessages(
    //the Id of the second person
    String receiverId,
    ReceiverType receiverType,
  ) async {
    List<MessageInfo> messages = [];
    try {
      Database db = await initialize();
      List<Map<String, dynamic>> list = await db.query(
        DBConfig.messages_table_name,
        where: '''(
              (
                receiver_id = '$receiverId' AND sender_id = '${Get.find<UserController>().currentUser.id}'
              ) OR (
                sender_id = '$receiverId' AND receiver_id = '${Get.find<UserController>().currentUser.id}'
              )
            )
            AND receiver_type_id = '${receiverType == ReceiverType.individual ? '1' : receiverType == ReceiverType.group ? '2' : ''}'
            ''',
      );
      for (Map<String, dynamic> message in list) {
        messages.add(MessageInfo.fromLocalDB(message));
      }
    } catch (error) {
      _echo(variableName: "error", functionName: "getMessages", data: error);
    }
    return messages;
  }

  Future<bool> resetDB() async {
    try {
      Database db = await initialize();
      await db.execute("DROP TABLE ${DBConfig.messages_table_name};");
      await createDB(db);
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "deleteMessage", data: error);
      return false;
    }
  }

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("MESSAGES_DB_HELPER $functionName $variableName: $data ");
  }

  Future<MessageInfo?> getLastMessage(
    //the Id of the second person
    String receiverId,
    ReceiverType receiverType,
  ) async {
    try {
      Database db = await initialize();
      List<Map<String, dynamic>> list = await db.query(
        DBConfig.messages_table_name,
        where: '''
            (
              (
                receiver_id = '$receiverId' AND sender_id = '${Get.find<UserController>().currentUser.id}'
              ) OR (
                sender_id = '$receiverId' AND receiver_id = '${Get.find<UserController>().currentUser.id}'
              )
            )
            AND receiver_type_id = '${receiverType == ReceiverType.individual ? '1' : receiverType == ReceiverType.group ? '2' : ''}'
            ''',
        orderBy: "created_at DESC",
      );
      if (list.isNotEmpty) {
        return MessageInfo.fromLocalDB(list.first);
      }
    } catch (error) {
      _echo(variableName: "error", functionName: "getLastMessage", data: error);
    }
  }
}
