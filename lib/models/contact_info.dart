class ContactInfo {
  late String _name;
  late List<String> _phoneNumbers;
  String? _firebaseId;
  String? _profilePicture;
  String? _bio;
  String? _lastMessage;
  DateTime? _messageDate;

  String get name => _name;
  List<String> get phoneNumbers => _phoneNumbers;
  String? get firebaseId => _firebaseId;
  String? get bio => _bio;
  String? get profilePicture => _profilePicture;
  String? get lastMessage => _lastMessage;
  DateTime? get messageDate => _messageDate;

  ContactInfo({
    required String name,
    required List<String> phoneNumbers,
    String? firebaseId,
    String? profilePicture,
    String? bio,
  }) {
    _phoneNumbers = phoneNumbers;
    _name = name;
    _firebaseId = firebaseId;
    _profilePicture = profilePicture;
    _bio = bio;
  }

  ContactInfo.fromLocalDB(Map<String, dynamic> data,
      [DateTime? messageDate, String? lastMessage]) {
    _phoneNumbers = [data["phone"]];
    _name = data["name"];
    _firebaseId = data["firebase_id"];
    _profilePicture = data["profile_picture"];
    _bio = data["bio"];
    _lastMessage = lastMessage;
    _messageDate = messageDate;
  }

  Map<String, dynamic> toMap() {
    return {
      "phone": phoneNumbers,
      "name": name,
      "firebase_id": firebaseId,
      "bio": bio,
      "profile_picture": profilePicture,
    };
  }

  @override
  String toString() {
    return 'ContactInfo(name: $name, phoneNumbers: $phoneNumbers, firebaseId: $firebaseId, profilePicture: $profilePicture, bio: $bio)';
  }

  ContactInfo copyWith({
    String? name,
    List<String>? phoneNumbers,
    String? firebaseId,
    String? bio,
    String? profilePicture,
    String? lastMessage,
  }) {
    return ContactInfo(
      name: name ?? this.name,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      firebaseId: firebaseId ?? this.firebaseId,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactInfo &&
        other._name == _name &&
        other._phoneNumbers == _phoneNumbers &&
        other._firebaseId == _firebaseId &&
        other._profilePicture == _profilePicture &&
        other._bio == _bio &&
        other._lastMessage == _lastMessage &&
        other._messageDate == _messageDate;
  }

  @override
  int get hashCode {
    return _name.hashCode ^
        _phoneNumbers.hashCode ^
        _firebaseId.hashCode ^
        _profilePicture.hashCode ^
        _bio.hashCode ^
        _lastMessage.hashCode ^
        _messageDate.hashCode;
  }
}
