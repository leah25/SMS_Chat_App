import 'package:chat_app/SignIn_Screen.dart';
import 'package:flutter/material.dart';

import 'Chat_Screen.dart';
import 'Services/Auth.dart';
import 'Services/helping.dart';
import 'Widgets/Database.dart';
import 'Widgets/widget.dart';

Authentications authentications = Authentications();
Database database = Database();

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  TextEditingController userTextEditingController = TextEditingController();
  TextEditingController mailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  signing() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInputMap = {
        'name': userTextEditingController.text,
        'email': mailTextEditingController.text,
      };

      HelperFunction.setEmailPreference(mailTextEditingController.text);
      HelperFunction.setNamedUserPreference(userTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authentications
          .signingUp(
              mailTextEditingController.text, passTextEditingController.text)
          .then((value) {
        //print('${value.uid}');

        database.updateUser(userInputMap);
        HelperFunction.setLoggedInUserPreference(true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChatScreen();
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.yellow.shade800),
                  backgroundColor: Colors.black,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 70,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty || value.length < 4
                                    ? "Please enter username, should be more than 4 characters "
                                    : null;
                              },
                              controller: userTextEditingController,
                              style: kInputText,
                              decoration: kInputDecoration.copyWith(
                                  hintText: 'Username'),
                            ),
                            TextFormField(
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)
                                    ? null
                                    : "Enter a valid Email Address  format";
                              },
                              controller: mailTextEditingController,
                              style: kInputText,
                              decoration:
                                  kInputDecoration.copyWith(hintText: 'Email'),
                            ),
                            TextFormField(
                              validator: (value) {
                                return value.length < 6
                                    ? "Your password should be more than 6 characters"
                                    : null;
                              },
                              controller: passTextEditingController,
                              style: kInputText,
                              decoration: kInputDecoration.copyWith(
                                  hintText: 'Password'),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          signing();
//                          setState(() {
//                            isLoading = false;
//                          });
                        },
                        child: Container(
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
                            'Sign Up ',
                            style: TextStyle(
                                color: Colors.yellow.shade800, fontSize: 20.0),
                          )),
                        ),
                      ),
//                SizedBox(height: 15.0,),
//                Container(
//                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.symmetric(vertical: 16.0),
//
//                  decoration: BoxDecoration(
//                    color: Colors.yellow.shade100,
//                    borderRadius: BorderRadius.circular(30),
//                  ),
//                  child: Center(child: Text('Sign In with Google ', style: TextStyle(color: Colors.black,fontSize: 20.0),)),
//                ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an Account?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                            },
                            child: Text(
                              'Sign In',
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
