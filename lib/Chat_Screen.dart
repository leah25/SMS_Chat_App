import 'package:chat_app/Conversations.dart';
import 'package:chat_app/Services/helping.dart';
import 'package:flutter/material.dart';

import 'Search_Screen.dart';
import 'Services/Auth.dart';
import 'Services/Constants.dart';
import 'SignIn_Screen.dart';
import 'Widgets/Database.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Authentications authentications = Authentications();
  Database database = Database();

  Stream chatStream;
  Widget ChatList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatTile(
                      snapshot.data.documents[index].data['chatID']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constant.myName, ""),
                      snapshot.data.documents[index].data['chatID']);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constant.myName = await HelperFunction.getNamedUserPreference();
    database.getChats(Constant.myName).then((value) {
      setState(() {
        chatStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50.0,
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 80.0),
          child: Text(
            'SMS',
            style: TextStyle(color: Colors.yellow.shade800),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('images/logo.png'),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authentications.signingOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.exit_to_app, color: Colors.yellow.shade800),
            ),
          )
        ],
      ),
      body: ChatList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.search,
          color: Colors.yellow.shade800,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Conversation(
                        conversationID: chatRoomId,
                      )));
        },
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 40.0,
                alignment: Alignment.center,
                child: Text(
                  '${userName.substring(0, 1).toUpperCase()}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade800,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                userName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );
  }
}
