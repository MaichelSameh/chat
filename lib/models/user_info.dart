class UserInfo {
  UserInfo({
    required String bio,
    required String coverURL,
    required List<String> fcm,
    required String id,
    required String profileURL,
    required String name,
    required String phoneNumber,
  }) {
    _bio = bio;
    _coverURL = coverURL;
    _fcm = fcm;
    _id = id;
    _profileURL = profileURL;
    _name = name;
    _phoneNumber = phoneNumber;
  }

  UserInfo.empty() {
    _bio = "";
    _coverURL = "";
    _fcm = [];
    _id = "";
    _profileURL = "";
    _name = "";
    _phoneNumber = "";
  }

  UserInfo.fromFirebase(Map<String, dynamic> data, String id) {
    _bio = data["bio"];
    _fcm = data["fcm"] ?? [];
    _id = id;
    _profileURL = data["profile_url"];
    _name = data["name"];
    _phoneNumber = data["phone"];
    _coverURL = data["cover_url"];
  }

  late String _bio;
  late String _coverURL;
  late List<String> _fcm;
  late String _id;
  late String _name;
  late String _phoneNumber;
  late String _profileURL;

  String get bio => _bio;

  String get coverURL => _coverURL;

  List<String> get fcm => _fcm;

  String get id => _id;

  String get profileURL => _profileURL;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      "bio": bio,
      "cover_url": coverURL,
      "fcm": fcm,
      "profile_url": profileURL,
      "name": name,
      "phone": phoneNumber,
    };
  }
}
