enum Gender { male, female }

class UserInfo {
  UserInfo({
    required String name,
    required Gender gender,
    required String email,
    required String id,
    required int grade,
    required String imageURL,
  }) {
    _email = email;
    _gender = gender;
    _grade = grade;
    _id = id;
    _name = name;
    _imageURL = imageURL;
  }

  UserInfo.empty() {
    _email = "maichelsameh622@gmail.com";
    _gender = Gender.male;
    _grade = 17;
    _id = "0";
    _name = "Maichel Sameh";
    _imageURL = "";
  }

  UserInfo.fromFirebase(Map<String, dynamic> json, String id) {
    _email = json["email"];
    _gender = json["gender"] == "male" ? Gender.male : Gender.female;
    _grade = int.parse(json["grade"].toString());
    _id = id;
    _name = json["name"];
    _imageURL = json["image_url"] ?? "";
  }

  late String _email;
  late Gender _gender;
  late int _grade;
  late String _id;
  late String _imageURL;
  late String _name;

  @override
  String toString() {
    return 'UserInfo(_email: $_email, _name: $_name, _id: $_id, _imageURL: $_imageURL, _grade: $_grade, _gender: $_gender)';
  }

  String get email => _email;

  String get name => _name;

  String get id => _id;

  int get grade => _grade;

  Gender get gender => _gender;

  String get imageURL => _imageURL;

  Map<String, dynamic> toJSON() {
    return {
      "email": email,
      "gender": gender == Gender.male ? "male" : "female",
      "grade": grade,
      "image_url": imageURL,
      "name": name,
    };
  }
}
