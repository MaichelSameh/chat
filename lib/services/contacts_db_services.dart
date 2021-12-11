import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact_info.dart';
import '../models/user_info.dart';
import '../controllers/user_controller.dart';

class ContactsDBServices {
  // ignore: constant_identifier_names
  static const String _contacts_table_name = "contacts_table";
  // ignore: constant_identifier_names
  static const String _fcm_table_name = "fcm_table";

  static Database? _db;

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
      _db = await openDatabase(
        dir.path + _contacts_table_name,
        version: 1,
        onCreate: (db, version) {
          db.execute('''
        CREATE TABLE $_contacts_table_name (
          id INTEGER NOT NULL PRIMARY KEY,
          phone TEXT NOT NULL,
          name TEXT NOT NULL,
          firebase_id TEXT
        );
        CREATE TABLE _fcm_table_name(
          id INTEGER NOT NULL PRIMARY KEY,
          fcm TEXT NOT NULL,
          user_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES $_contacts_table_name(id)
        );
        ''');
          SharedPreferences.getInstance()
              .then((pref) => pref.setInt(_contacts_table_name, 1));
          SharedPreferences.getInstance()
              .then((pref) => pref.setInt(_fcm_table_name, 1));
        },
      );
      return _db!;
    }
  }

  Future<bool> insertContact(ContactInfo contact) async {
    try {
      Database db = await _database();
      SharedPreferences pref = await SharedPreferences.getInstance();
      MyUserInfo? user =
          await UserController().searchUserByPhone(contact.phoneNumbers.first);
      int id = await db.insert(
        _contacts_table_name,
        {
          "id": pref.getInt(_contacts_table_name) ?? 1,
          "phone": contact.toMap()["phone"].first,
          "name": contact.toMap()["name"],
          "firebase_id": contact.toMap()["firebase_id"] ??
                  (user ?? MyUserInfo.empty()).id.isEmpty
              ? null
              : (user ?? MyUserInfo.empty()).id,
        },
      );
      pref.setInt(_contacts_table_name, id + 1);
      if (user != null) {
        for (String fcm in user.fcm) {
          id = await db.insert(_fcm_table_name, {
            "user_id": id,
            "fcm": fcm,
            "id": pref.getInt(_fcm_table_name) ?? 1
          });
          pref.setInt(_fcm_table_name, id + 1);
        }
      }
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "insertContact", data: error);
      return false;
    }
  }

  Future<bool> insertIfAbsent(ContactInfo contact) async {
    try {
      Database db = await _database();
      List<Map<String, dynamic>> list = await db.query(_contacts_table_name,
          where: "phone = ? OR name = ?",
          whereArgs: [contact.phoneNumbers, contact.name]);
      if (list.isEmpty) {
        insertContact(contact);
      }
      return true;
    } catch (error) {
      _echo(variableName: "error", functionName: "insertContact", data: error);
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      Database db = await _database();
      db.delete(_contacts_table_name, where: "id = $id");
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
          await db.query(_contacts_table_name, where: "id = $id");
      db.update(
        _contacts_table_name,
        {
          "id": contacts.first["id"],
          "phone": contact.toMap()["phone"],
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
      List<Map<String, dynamic>> list = await db.query(_contacts_table_name);
      for (Map<String, dynamic> contact in list) {
        contacts.add(ContactInfo.fromLocalDB(contact));
      }
    } catch (error) {
      _echo(variableName: "error", functionName: "updateContact", data: error);
    }
    return contacts;
  }
}
