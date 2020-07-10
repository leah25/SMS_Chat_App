import 'package:flutter/material.dart';

Widget appBarMain (BuildContext context0){
  return AppBar(
    elevation: 50.0,
    backgroundColor: Colors.black,
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 100.0),
      child: Text('SMS',style: TextStyle(color:Colors.yellow.shade800),),
    ),
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image.asset('images/logo.png'),
    ),

  );
}

const  kInputDecoration = InputDecoration(
hintText: 'Email',

focusedBorder: UnderlineInputBorder(
borderSide: BorderSide(

color: Colors.black,

),
),
);

const kInputText = TextStyle(color:Colors.black);
