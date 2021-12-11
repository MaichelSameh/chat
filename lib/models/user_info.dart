class MyUserInfo {
  MyUserInfo({
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

  MyUserInfo.empty() {
    _bio = "Hi there I am using app";
    _coverURL = "";
    _fcm = [];
    _id = "";
    _profileURL =
        "https://firebasestorage.googleapis.com/v0/b/chat-app-81826.appspot.com/o/users%2Funknown-person-icon-27.jpg?alt=media&token=bfa3dab1-5605-43c0-a73a-979b25a4862b";
    _name = "";
    _phoneNumber =
        "https://firebasestorage.googleapis.com/v0/b/chat-app-81826.appspot.com/o/users%2Funknown-person-icon-27.jpg?alt=media&token=bfa3dab1-5605-43c0-a73a-979b25a4862b";
  }

  MyUserInfo.fromFirebase(Map<String, dynamic> data, String id) {
    List<String> fcm = [];
    List<dynamic> list = data["fcm"] ?? [];
    for (var temp in list) {
      fcm.add(temp.toString());
    }
    _bio = data["bio"];
    _fcm = fcm;
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

  MyUserInfo copyWith({
    String? bio,
    String? coverURL,
    String? profileURL,
    String? name,
    String? phoneNumber,
    String? id,
    List<String>? fcm,
  }) {
    return MyUserInfo(
      bio: bio ?? this.bio,
      coverURL: coverURL ?? this.coverURL,
      fcm: fcm ?? this.fcm,
      id: id ?? this.id,
      profileURL: profileURL ?? this.profileURL,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
