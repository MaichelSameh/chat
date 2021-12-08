import 'package:intl/intl.dart';

class GroupInfo {
  GroupInfo({
    required DateTime createdAt,
    String coverURL = "",
    required String description,
    required String iconURL,
    required String id,
    required String name,
    required List<String> users,
  }) {
    _createdAt = createdAt;
    _coverURL = coverURL;
    _description = description;
    _iconURL = iconURL;
    _id = id;
    _name = name;
    _users = users;
  }

  GroupInfo.fromFirebase(Map<String, dynamic> data, String id) {
    _createdAt = data["createdAt"];
    _coverURL = data[""];
    _description = data["description"];
    _iconURL = data["iconURL"];
    _id = id;
    _name = data["name"];
    _users = data["users"];
  }

  late String _coverURL;
  late DateTime _createdAt;
  late String _description;
  late String _iconURL;
  late String _id;
  late String _name;
  late List<String> _users;

  @override
  String toString() {
    String users = "[\n";
    for (String user in this.users) {
      users += user + ",\n";
    }
    users += "],";
    return 'GroupInfo(createdAt: $createdAt, description: $description, iconURL: $iconURL, id: $id, name: $name, users: $users, coverURL: $coverURL)';
  }

  DateTime get createdAt => _createdAt;

  String get description => _description;

  String get iconURL => _iconURL;

  String get id => _id;

  String get name => _name;

  List<String> get users => _users;

  String get coverURL => _coverURL;

  Map<String, dynamic> toMap() {
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "cover_url": coverURL,
      "description": description,
      "icon_url": iconURL,
      "name": name,
      "users": users,
    };
  }
}
