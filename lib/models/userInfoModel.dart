import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toMap());

class UserInfoModel {
  UserInfoModel({
    required this.id,
    required this.client,
    required this.email,
    required this.role,
    required this.profilePic,
    required this.firstName,
    required this.lastName,
    required this.accessToken,
    required this.refreshToken,
  });

  final String id;
  final String client;
  final String email;
  final String role;
  String profilePic;
  String firstName;
  String lastName;
  String accessToken;
  String refreshToken;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        id: json["_id"],
        client: json["client"],
        email: json["email"],
        role: json["role"],
        profilePic: json["profile_pic"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "client": client,
        "email": email,
        "role": role,
        "profile_pic": profilePic,
        "first_name": firstName,
        "last_name": lastName,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
