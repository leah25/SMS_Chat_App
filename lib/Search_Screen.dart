import 'package:chat_app/Conversations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Services/Constants.dart';
import 'Widgets/Database.dart';
import 'Widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchTextEditingController = TextEditingController();
  Database database = Database();
  QuerySnapshot querySnapshot;

  Widget searchList() {
    return querySnapshot != null
        ? ListView.builder(
            itemCount: querySnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return messageTile(
                searchName: querySnapshot.documents[index].data['name'],
                searchEmail: querySnapshot.documents[index].data['email'],
              );
            })
        : Container();
  }

  initialValue() async {
    await database.getUser(searchTextEditingController.text).then((value) {
      setState(() {
        querySnapshot = value;
      });
    });
  }

  createChatScreenConversations({String userName}) {
    String chatScreenId = getChatId(userName, Constant.myName);
    List<String> users = [userName, Constant.myName];
    Map<String, dynamic> chatScreenMap = {
      'users': users,
      'chatID': chatScreenId
    };

    Database().createChats(chatScreenId, chatScreenMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Conversation(
                  conversationID: chatScreenId,
                )));
  }

  Widget messageTile({String searchName, String searchEmail}) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                searchName,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
              ),
              Text(
                searchEmail,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatScreenConversations(userName: searchName);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.grey.shade800,
                  Colors.yellow.shade100,
                ]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Message',
                  style: TextStyle(color: Colors.yellow.shade800),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.black54,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchTextEditingController,
                            decoration: InputDecoration(
                              hintText: '     Search Username',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: () {
                            initialValue();
                          },
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Center(
                                child: Icon(Icons.search,
                                    color: Colors.yellow.shade800)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                searchList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

getChatId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
