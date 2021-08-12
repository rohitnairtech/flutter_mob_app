import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/userInfoModel.dart';
import '../models/chatInfoModel.dart';

Future<Database> openDBFunc() async {
  final dbPath = join(await getDatabasesPath(), 'aib.db');

  final Database database = await openDatabase(dbPath, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE userInfo(_id TEXT PRIMARY KEY, client TEXT, email TEXT, role TEXT, profile_pic TEXT, first_name TEXT, last_name TEXT, accessToken TEXT, refreshToken TEXT)');
    await db.execute(
        'CREATE TABLE userChat(_id TEXT PRIMARY KEY, client TEXT, channel TEXT, flag TEXT, uniqueid TEXT, user_id TEXT, first_name TEXT, last_name TEXT, email TEXT, chats TEXT, notes TEXT, updatedAt TEXT, createdAt TEXT)');
  });

  return database;
}

Future<void> insertUserInfo(UserInfoModel userInfo) async {
  final db = await openDBFunc();

  await db.insert('userInfo', userInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> insertChat(ChatInfoModel chatInfo) async {
  final db = await openDBFunc();

  await db.insert('userChat', chatInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}
