import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/userInfoModel.dart';

import '../globals.dart' as globals;

import 'dart:convert';

import './homePage.dart';

Future<UserInfoModel> login(String email, String password) async {
  final response = await http.post(Uri.parse('http://localhost:5055/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}));

  print(response.statusCode);
  if (response.statusCode == 200) {
    globals.loggedIn = true;
    return userInfoModelFromJson(response.body);
  } else {
    globals.loggedIn = false;
    throw Exception('Failed to login.');
  }
}

Future<List> requestChatData() async {
  final response = await http.get(
      Uri.parse('http://localhost:5055/resources/chatdata?client=' +
          globals.userInfo.client),
      headers: <String, String>{
        'Authorization': 'Bearer ' + globals.userInfo.accessToken,
      });
  print(response.statusCode);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get chat data.');
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailField = TextEditingController();
  final pswdField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/flutter-logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: pswdField,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password',
                style: TextStyle(color: primaryColor, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  final UserInfoModel userInfo =
                      await login(emailField.text, pswdField.text);
                  // LoginData logindata = LoginData(email, pswd);

                  // String jsonData = jsonEncode(logindata);
                  globals.userInfo = userInfo;

                  final List chatData = await requestChatData();
                  //print(chatData);
                  print(chatData[0]);
                  globals.chatData = chatData;
                  // //print(jsonData);
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       content: Text(globals.userInfo.role +
                  //           ' ' +
                  //           globals.userInfo.firstName +
                  //           ' ' +
                  //           globals.userInfo.lastName),
                  //     );
                  //   },
                  // );

                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
