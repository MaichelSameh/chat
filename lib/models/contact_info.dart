class ContactInfo {
  late String _name;
  late List<String> _phoneNumbers;
  late String? _firebaseId;

  String get name => _name;
  List<String> get phoneNumbers => _phoneNumbers;
  String? get firebaseId => _firebaseId;

  ContactInfo({
    required String name,
    required List<String> phoneNumbers,
    String? firebaseId,
  }) {
    _phoneNumbers = phoneNumbers;
    _name = name;
    _firebaseId = firebaseId;
  }

  ContactInfo.fromLocalDB(Map<String, dynamic> data) {
    _phoneNumbers = [data["phone"]];
    _name = data["name"];
    _firebaseId = data["firebase_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "phone": phoneNumbers,
      "name": name,
      "firebase_id": firebaseId,
    };
  }

  @override
  String toString() =>
      'ContactInfo(name: $name, phone_numbers: $phoneNumbers, firebase_id: $firebaseId)';

  ContactInfo copyWith({
    String? name,
    List<String>? phoneNumbers,
    String? firebaseId,
  }) {
    return ContactInfo(
      name: name ?? this.name,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      firebaseId: firebaseId ?? this.firebaseId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactInfo &&
        other._name == _name &&
        other._phoneNumbers == _phoneNumbers &&
        other._firebaseId == _firebaseId;
  }

  @override
  int get hashCode =>
      _name.hashCode ^ _phoneNumbers.hashCode ^ _firebaseId.hashCode;
}
