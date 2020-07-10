import 'package:chat_app/Services/Constants.dart';
import 'package:chat_app/Widgets/Database.dart';
import 'package:chat_app/Widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  String conversationID;
  Conversation({this.conversationID});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController message = TextEditingController();

  Stream conversationStream;
  Database database = Database();
  Widget messageList() {
    return StreamBuilder(
        stream: conversationStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data['message'],
                        snapshot.data.documents[index].data['from'] ==
                            Constant.myName);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (message.text != null) {
      Map<String, dynamic> messageMap = {
        'message': message.text,
        'from': Constant.myName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      database.addConversation(widget.conversationID, messageMap);
      message.text = '';
    }
  }

  @override
  void initState() {
    database.getConversation(widget.conversationID).then((value) {
      setState(() {
        conversationStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: <Widget>[
          messageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: '     New Message',
                          hintStyle: TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Center(
                            child: Icon(Icons.send,
                                color: Colors.yellow.shade800)),
                      ),
                    ),
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

class MessageTile extends StatelessWidget {
  final String messageText;
  final bool isFrom;
  MessageTile(this.messageText, this.isFrom);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isFrom ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isFrom ? Colors.black : Colors.white,
            borderRadius: isFrom
                ? BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0),
                  ),
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                offset: Offset(0, 0),
                color: Colors.yellow.shade800,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              messageText,
              style: isFrom
                  ? TextStyle(color: Colors.white, fontSize: 16.0)
                  : TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
