import 'package:chat_app/SignIn_Screen.dart';
import 'package:flutter/material.dart';

import 'Chat_Screen.dart';
import 'Services/helping.dart';
import 'SignUp_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLogedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getLoggedInUserPreference().then((value) {
      setState(() {
        userIsLogedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.yellow.shade800,
          //primarySwatch:Colors.yellow.shade800,
          scaffoldBackgroundColor: Colors.grey.shade600,
          cursorColor: Colors.yellow.shade800,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userIsLogedIn != null
            ? userIsLogedIn ? ChatScreen() : SignIn()
            : Container(
                child: Center(
                  child: SignUp(),
                ),
              ));
  }
}
