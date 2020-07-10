import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Chat_Screen.dart';
import 'Services/Auth.dart';
import 'Services/helping.dart';
import 'SignUp_Screen.dart';
import 'Widgets/Database.dart';
import 'Widgets/widget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController mailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Authentications authentications = Authentications();
  Database database = Database();

  QuerySnapshot querySnapshot;
  initialSignIn() {
    if (formKey.currentState.validate()) {
      HelperFunction.setEmailPreference(mailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      database.getEmail(mailTextEditingController.text).then((value) {
        querySnapshot = value;
        HelperFunction.setEmailPreference(
            querySnapshot.documents[0].data['name']);
      });

      authentications
          .signingIn(
              mailTextEditingController.text, passTextEditingController.text)
          .then((value) {
        if (value != null) {
          HelperFunction.setLoggedInUserPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChatScreen();
          }));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: mailTextEditingController,
                        style: kInputText,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)
                              ? null
                              : "Enter a valid Email Address  format";
                        },
                      ),
                      TextFormField(
                        controller: passTextEditingController,
                        style: kInputText,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          return value.length < 6
                              ? "Your password should be more than 6 characters"
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 17.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.grey.shade800,
                      Colors.yellow.shade700,
                    ]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Text(
                    'Sign In ',
                    style: TextStyle(
                        color: Colors.yellow.shade800, fontSize: 20.0),
                  )),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Text(
                    'Sign In with Google ',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  )),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade800,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 80.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
