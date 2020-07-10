import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUser(String userName) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .getDocuments();
  }

  getEmail(String userMail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userMail)
        .getDocuments();
  }

  updateUser(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChats(String chats, chatMap) {
    Firestore.instance
        .collection('Chat')
        .document(chats)
        .setData(chatMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversation(String chats, messageMap) {
    Firestore.instance
        .collection('Chat')
        .document(chats)
        .collection('messaging')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversation(String chats) async {
    return await Firestore.instance
        .collection('Chat')
        .document(chats)
        .collection('messaging')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChats(String userName) async {
    return await Firestore.instance
        .collection('Chat')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
