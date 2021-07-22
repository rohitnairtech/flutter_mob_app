import 'package:flutter/material.dart';

import '../models/userInfoModel.dart';

class UserInfo extends ChangeNotifier {
  var userinfo;
  int get getUserInfo {
    return userinfo;
  }

  void incrementCounter() {
    userinfo += 1;
    notifyListeners();
  }

  void setUserInfo(UserInfoModel data) {
    userinfo = data;
    notifyListeners();
  }
}
