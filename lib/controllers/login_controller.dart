import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import 'user_controller.dart';

class LoginController extends GetxController {
  //adding email field to hold the email in case we need to use it later for example when we try to send a reset code
  String _email = "";

  String _tokenid = "";

  String get email => _email;

  String get tokenid => _tokenid;

  //in this function we are printing the outputs of this class with its reference
  void echo({
    required String variableName,
    required String functionName,
    required String data,
  }) {
    // ignore: avoid_print
    print("LOGIN_CONTROLLER $functionName $variableName: $data");
  }

  //trying to login and register the user data
  Future<bool> login(String email, String password) async {
    return true;
  }

  //saving the required information to get re-authenticate the user or to send a new request
  // ignore: unused_element
  Future<void> _saveLoginData(
    String tokenid,
    String email,
    String password,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("tokenid", tokenid);
    pref.setString("email", email);
    pref.setString("password", password);
  }

  // ending a validation code to the given email to reset the password
  Future<bool> sendCodeEmail(String email) async {
    return true;
  }

  //validating if the getting code is valid or not
  Future<bool> validateCode(String code) async {
    return true;
  }

  //resetting the password again
  Future<bool> resetPassword(String password) async {
    return true;
  }

  //changing the password by using the old one
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    return true;
  }

  //forgetting the user data and logging the user out
  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    return true;
  }

  // ignore: unused_element
  Future<void> _saveUserData(
    String name,
    String id,
    String gender,
    int grade,
    String imageURL,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("first_name", name);
    pref.setString("id", id);
    pref.setString("gender", gender);
    pref.setInt("grade", grade);
    pref.setString("image_url", imageURL);
  }

  Future<void> _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String name = pref.getString("name") ?? "";
    String id = pref.getString("id") ?? "";
    String gender = pref.getString("gender") ?? "male";
    int grade = pref.getInt("grade") ?? 0;
    String imageURL = pref.getString("image_url") ?? "";

    Get.find<UserController>().setCurrentUser(
      UserInfo(
        email: email,
        gender: gender == "male" ? Gender.male : Gender.female,
        grade: grade,
        id: id,
        name: name,
        imageURL: imageURL,
      ),
    );
  }

  //trying to login by using only the saved data without any extra information
  Future<bool> tryAutoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("tokenid")) {
      _tokenid = pref.getString("tokenid")!;
      _email = pref.getString("email")!;
      await _getUserData();
      update();
      return true;
    }
    return false;
  }
}
