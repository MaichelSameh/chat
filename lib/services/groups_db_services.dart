import 'package:sqflite/sqflite.dart';

import '../models/group_info.dart';

class GroupDBServices {
  // ignore: constant_identifier_names
  static const String _groups_table_name = "groups_table";

  static Database? _db;

  void _echo({
    required String variableName,
    required String functionName,
    required dynamic data,
  }) {
    // ignore: avoid_print
    print("GROUPS_DB_SERVICES $functionName $variableName: $data ");
  }
}
