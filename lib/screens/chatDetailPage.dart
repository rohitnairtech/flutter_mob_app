import 'package:flutter/material.dart';

import '../globals.dart' as globals;

import '../models/chatMessageModel.dart';

//import 'package:toggle_switch/toggle_switch.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

String chatUserName = '';
bool flag = true;

List<dynamic> getCurrChat() {
  final chatData = globals.chatData;
  final currChatId = globals.currChatId;
  for (int i = 0; i < chatData.length; i++) {
    final thisChat = chatData[i];
    if (thisChat['_id'] == currChatId) {
      chatUserName = thisChat['first_name'] + ' ' + thisChat['last_name'];
      flag = thisChat['flag'] == 'true' ? true : false;
      return thisChat['chats'];
    }
  }
  throw Exception("Couldn't find the requested chat");
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // List<ChatMessage> messages = [
  //   ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  //   ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Hey Kriss, I am doing fine dude. wbu?",
  //       messageType: "sender"),
  //   ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  //   ChatMessage(
  //       messageContent: "Is there any thing wrong?", messageType: "sender"),
  // ];

  List<ChatMessage> messages = [];

  List<dynamic> currChat = getCurrChat();

  final msgField = TextEditingController();

  @override
  void initState() {
    for (int i = 0; i < currChat.length; i++) {
      final chat = currChat[i];
      if (chat.containsKey('message')) {
        messages.add(ChatMessage(
            messageContent: chat['message'], messageType: 'receiver'));
      } else if (chat.containsKey('reply')) {
        messages.add(ChatMessage(
            messageContent: chat['reply']['text'], messageType: 'sender'));
      }
    }

    super.initState();
  }

  void addMsg(String msg) {
    setState(() {
      messages.add(ChatMessage(messageContent: msg, messageType: 'sender'));
    });
  }

  void changeGlobalFlag(bool flagValue) {
    final chatData = globals.chatData;
    final currChatId = globals.currChatId;

    for (int i = 0; i < chatData.length; i++) {
      if (chatData[i]['_id'] == currChatId) {
        chatData[i]['flag'] = flagValue ? 'true' : 'false';
        break;
      }
    }
  }

//WORK ON SOCKET IO CONNECTION IN THE HOME PAGE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        chatUserName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Switch(
                    value: flag,
                    onChanged: (bool toggled) {
                      changeGlobalFlag(toggled);
                      setState(() {
                        flag = toggled;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: msgField,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      addMsg(msgField.text);
                      msgField.clear();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
