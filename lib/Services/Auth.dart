import 'package:firebase_auth/firebase_auth.dart';

import 'User.dart';

class Authentications {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// private function, that converts firebase user into user id.
  User _currentUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signingIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //this saves the user from firebase.
      FirebaseUser firebaseUser = result.user;
      return _currentUser(firebaseUser);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  Future signingUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _currentUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future passwordReset(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {}
  }

  Future signingOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
