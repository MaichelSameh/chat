class MyUserInfo {
  MyUserInfo({
    required String bio,
    required String coverURL,
    required String id,
    required String profileURL,
    required String name,
    required String phoneNumber,
    required String countryCode,
  }) {
    _bio = bio;
    _coverURL = coverURL;
    _id = id;
    _profileURL = profileURL;
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
  }

  MyUserInfo.empty() {
    _bio = "Hi there I am using app";
    _coverURL = "";
    _id = "";
    _profileURL =
        "https://firebasestorage.googleapis.com/v0/b/chat-app-81826.appspot.com/o/users%2Funknown-person-icon-27.jpg?alt=media&token=bfa3dab1-5605-43c0-a73a-979b25a4862b";
    _name = "";
    _phoneNumber =
        "https://firebasestorage.googleapis.com/v0/b/chat-app-81826.appspot.com/o/users%2Funknown-person-icon-27.jpg?alt=media&token=bfa3dab1-5605-43c0-a73a-979b25a4862b";
    _countryCode = "+20";
  }

  MyUserInfo.fromFirebase(Map<String, dynamic> data, String id) {
    _bio = data["bio"];
    _id = id;
    _profileURL = data["profile_url"];
    _name = data["name"];
    _phoneNumber = data["phone"];
    _coverURL = data["cover_url"];
    _countryCode = data["country_code"];
  }

  late String _bio;
  late String _countryCode;
  late String _coverURL;
  late String _id;
  late String _name;
  late String _phoneNumber;
  late String _profileURL;

  String get bio => _bio;

  String get countryCode => _countryCode;

  String get coverURL => _coverURL;

  String get id => _id;

  String get profileURL => _profileURL;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      "bio": bio,
      "cover_url": coverURL,
      "profile_url": profileURL,
      "name": name,
      "phone": phoneNumber,
      "country_code": countryCode,
    };
  }

  MyUserInfo copyWith({
    String? bio,
    String? coverURL,
    String? profileURL,
    String? name,
    String? phoneNumber,
    String? id,
    String? countryCode,
  }) {
    return MyUserInfo(
      bio: bio ?? this.bio,
      coverURL: coverURL ?? this.coverURL,
      countryCode: countryCode ?? this.countryCode,
      id: id ?? this.id,
      profileURL: profileURL ?? this.profileURL,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return "MyUserInfo(${toMap()})";
  }
}
