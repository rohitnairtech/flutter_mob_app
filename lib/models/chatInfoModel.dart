import 'dart:convert';

ChatInfoModel chatInfoModelFromJson(String str) =>
    ChatInfoModel.fromJson(json.decode(str));

String chatInfoModelToJson(ChatInfoModel data) => json.encode(data.toMap());

class ChatInfoModel {
  final String id;
  String flag;
  final String client;
  final String channel;
  final String uniqueid;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  List<dynamic> chats;
  List<String> notes;
  String updatedAt;
  final String createdAt;

  ChatInfoModel(
      {required this.id,
      required this.flag,
      required this.client,
      required this.channel,
      required this.uniqueid,
      required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.chats,
      required this.notes,
      required this.updatedAt,
      required this.createdAt});

  Map<String, dynamic> toMap() => {
        '_id': id,
        'flag': flag,
        'client': client,
        'channel': channel,
        'uniqueid': uniqueid,
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'chats': chats.toString(),
        'notes': notes.toString(),
        'updatedAt': updatedAt,
        'createdAt': createdAt
      };

  factory ChatInfoModel.fromJson(Map<String, dynamic> json) => ChatInfoModel(
      id: json['_id'],
      flag: json['flag'],
      client: json['client'],
      channel: json['channel'],
      uniqueid: json['uniqueid'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      chats: json['chats'],
      notes: json['notes'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt']);
}
