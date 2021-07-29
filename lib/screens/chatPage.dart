import 'package:flutter/material.dart';

//model
import '../models/chatUsersModel.dart';

//state
import '../globals.dart' as globals;

//WORK ON SOCKET IO CONNECTION IN THE HOME PAGE

//widget
import '../widgets/conversationList.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

String dateTimeToDays(String dateTimeStr) {
  final chatDate = DateTime.parse(dateTimeStr);
  final currDate = DateTime.now();

  final daysDiff = currDate.difference(chatDate).inDays;

  if (daysDiff == 0) {
    return 'today';
  } else if (daysDiff == 1) {
    return 'yesterday';
  } else {
    return '$daysDiff days';
  }
}

class _ChatPageState extends State<ChatPage> {
  final chatList = globals.chatData;

  List<ChatUsers> chatUsers = [];

  List<ChatUsers> filteredList = [];

  final searchField = TextEditingController();

  void searchOperator(String searchStr) {
    setState(() {
      if (identical(searchStr, '')) {
        filteredList = chatUsers;
      } else {
        filteredList = chatUsers
            .where((user) =>
                user.name.toLowerCase().contains(searchStr.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    for (int i = 0; i < chatList.length; i++) {
      final chat = chatList[i];
      //final lastMsg = chat['chats'].last;
      final userList = ChatUsers(
          id: chat['_id'],
          name: chat['first_name'] + ' ' + chat['last_name'],
          messageText: chat['channel'],
          imageURL: "images/userImage8.jpeg",
          time: dateTimeToDays(chat['createdAt']));
      chatUsers.add(userList);
    }
    filteredList = List.of(chatUsers);

    IO.Socket socket = IO.io(globals.baseUrl);
    socket.onConnect((_) {
      print('connectedddd');
      socket.emit('room', globals.userInfo.client);
    });
    socket.on('test', (data) => print(data));

    socket.on('push', (data) {
      print('\n Pritn \n');
      print(data);
      print('\n Pritn \n');
    });
    socket.on('activity', (data) {
      print('\n Actrivi \n');
      print(data);
      print('\n Actrivi \n');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: InkWell(
                        onTap: () {
                          print("Logout pressed");
                          globals.loggedIn = false;
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.logout,
                              color: Colors.pink,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  controller: searchField,
                  onChanged: (text) {
                    print('First text field: $text');
                    searchOperator(text);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    suffixIcon: searchField.text.length == 0
                        ? null
                        : IconButton(
                            onPressed: () {
                              searchField.clear();
                              searchOperator('');
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade600,
                              size: 20,
                            )),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: filteredList.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  id: filteredList[index].id,
                  name: filteredList[index].name,
                  messageText: filteredList[index].messageText,
                  imageUrl: filteredList[index].imageURL,
                  time: filteredList[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
