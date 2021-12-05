import 'package:get/get.dart';

import '../models/user_info.dart';

class UserController extends GetxController {
  UserInfo _currentUser = UserInfo.empty();

  UserInfo get currentUser => _currentUser;

  void setCurrentUser(UserInfo user) {
    _currentUser = user;
    update();
  }
}
