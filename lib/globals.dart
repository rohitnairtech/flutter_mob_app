library globals;

import '../models/userInfoModel.dart';

const String baseUrl = 'http://localhost:5055/';

var userInfo = {} as UserInfoModel;

bool loggedIn = false;

List<dynamic> chatData = [];
