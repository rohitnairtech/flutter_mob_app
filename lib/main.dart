import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
//import 'package:logging/logging.dart';

import 'screens/homePage.dart';

import 'screens/loginPage.dart';

void main() {
  //checkLogin();
  runApp(MyApp());
}

bool loggedIn = false;

// Future<http.Response> checkLogin() async {
//   final response =
//       await http.get(Uri.parse('https://dashboard.aibuddha.in/api/checklogin'));

//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     loggedIn = true;
//   } else {
//     loggedIn = false;
//   }
//   return response;
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aibuddha - Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: (loggedIn ? HomePage() : LoginPage()),
    );
  }
}
