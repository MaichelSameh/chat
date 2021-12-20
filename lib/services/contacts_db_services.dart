import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/db_config.dart';
import '../controllers/user_controller.dart';
import '../models/contact_info.dart';
import '../models/message_info.dart';
import '../models/user_info.dart';
import 'messages_db_helper.dart';

class ContactsDBServices {
  static Database? _db;

  Future<void> createDatabase(Database db) async {
    await db.execute('''
        CREATE TABLE ${DBConfig.contacts_table_name} (
          id INTEGER NOT NULL PRIMARY KEY,
          phone TEXT NOT NULL,
          name TEXT NOT NULL,
          firebase_id TEXT,
          profile_picture TEXT,
          bio TEXT
        );
        ''');
    SharedPreferences.getInstance().then((pref) async {
      if (!pref.containsKey(DBConfig.contacts_table_name)) {
        await pref.setInt(DBConfig.contacts_table_name, 1);
      }
    });
  }

  Future<bool> insertContact(ContactInfo contact) async {
    try {
      Database db = await _database();
      SharedPreferences pref = await SharedPreferences.getInstance();
      int id = await db.insert(
        DBConfig.contacts_table_name,
        {
          "id": pref.getInt(DBConfig.contacts_table_name) ?? 1,
          "phone": "${contact.toMap()["phone"].first}",
          "name": contact.toMap()["name"],
          "firebase_id": contact.toMap()["firebase_id"],
          "bio": contact.toMap()["bio"],
          "profile_picture": contact.toMap()["profile_picture"],
        },
      );
      await pref.setInt(DBConfig.contacts_table_name, id + 1);
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "insertContact", data: error);
      return false;
    }
  }

  Future<bool> insertIfAbsent(ContactInfo contact) async {
    try {
      Database db = await _database();

      MyUserInfo? user =
          await UserController().searchUserByPhone(contact.phoneNumbers.first);
      if (user != null) {
        contact = contact.copyWith(
          firebaseId: user.id,
          bio: user.bio,
          profilePicture: user.profileURL,
        );
        List<Map<String, dynamic>> list = await db.query(
            DBConfig.contacts_table_name,
            where: "phone = '${contact.phoneNumbers.first}'");

        if (list.isEmpty) {
          await insertContact(contact);
        } else if (contact != ContactInfo.fromLocalDB(list.first)) {
          updateContact(list.first["id"], contact);
        }
      }
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "insertIfAbsent", data: error);
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      Database db = await _database();
      db.delete(DBConfig.contacts_table_name, where: "id = $id");
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "deleteContact", data: error);
      return false;
    }
  }

  Future<bool> updateContact(int id, ContactInfo contact) async {
    try {
      Database db = await _database();
      List<Map<String, dynamic>> contacts =
          await db.query(DBConfig.contacts_table_name, where: "id = $id");
      db.update(
        DBConfig.contacts_table_name,
        {
          "id": contacts.first["id"],
          "phone": contact.toMap()["phone"].first,
          "name": contact.toMap()["name"],
          "firebase_id": contact.toMap()["firebase_id"],
        },
        where: "id = $id",
      );
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "updateContact", data: error);
      return false;
    }
  }

  Future<List<ContactInfo>> getContacts() async {
    List<ContactInfo> contacts = [];
    try {
      Database db = await _database();
      List<Map<String, dynamic>> list = await db.query(
        DBConfig.contacts_table_name,
        where: "firebase_id IS NOT NULL",
        orderBy: "name ASC",
      );
      for (Map<String, dynamic> contact in list) {
        contacts.add(ContactInfo.fromLocalDB(contact));
      }
    } catch (error) {
      _echo(variableName: "error", functionName: "getContacts", data: error);
    }
    return contacts;
  }

  Future<List<ContactInfo>> searchContacts(String name) async {
    List<ContactInfo> contacts = [];
    try {
      Database db = await _database();
      List<Map<String, dynamic>> list = await db.query(
        DBConfig.contacts_table_name,
        where: "name = '$name'",
        orderBy: "name ASC",
      );
      for (Map<String, dynamic> contact in list) {
        contacts.add(ContactInfo.fromLocalDB(contact));
      }
    } catch (error) {
      _echo(variableName: "error", functionName: "searchContacts", data: error);
    }
    return contacts;
  }

  Future<void> resetDB() async {
    try {
      Database db = await _database();
      await db.execute('''DROP TABLE $DBConfig.contacts_table_name''');
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setInt(DBConfig.contacts_table_name, 1);
      await createDatabase(db);
    } catch (error) {
      _echo(variableName: "error", functionName: "clearDB", data: error);
    }
  }

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("CONTACT_DB_SERVICES $functionName $variableName: $data ");
  }

  Future<Database> _database() async {
    if (_db != null) {
      return _db!;
    } else {
      Directory dir = await path_provider.getApplicationDocumentsDirectory();
      _db = await openDatabase(dir.path + DBConfig.contacts_table_name,
          version: 1, onCreate: (db, version) async {
        await createDatabase(db);
      });

      return _db!;
    }
  }

  Future<List<ContactInfo>> getTextedContacts() async {
    List<ContactInfo> contacts = [];
    try {
      List<ContactInfo> allContacts = await getContacts();
      for (int i = 0; i < allContacts.length; i++) {
        MessageInfo? message = await MessagesDBHelper().getLastMessage(
            allContacts[i].firebaseId!, ReceiverType.individual);
        if (message != null) {
          Map<String, dynamic> contact = allContacts[i].toMap();
          contact["phone"] = contact["phone"].first;
          contacts.add(ContactInfo.fromLocalDB(
            contact,
            message.createdAt,
            message.message,
          ));
        }
      }
    } catch (error) {
      _echo(
          variableName: "error",
          functionName: "getTextedContacts",
          data: error);
    }
    contacts.sort(
        (first, second) => second.messageDate!.compareTo(first.messageDate!));
    return contacts;
  }
}
