import 'package:ChitChat/helpers/authenticate.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
//import 'package:ChitChat/views/about.dart';
import 'package:ChitChat/views/chatRoomScreen.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUserLoggedIn = false;

  getUserLoggedInState() async {
    await HelperFunctions.getUserLoggedInSP().then((value) {
      setState(() {
        _isUserLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chit Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(colorLinerBlue),
        scaffoldBackgroundColor: Color(colorLinerBlack),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isUserLoggedIn ? ChatRoom() : Authenticate(),
      //home: _isUserLoggedIn ? AboutPage() : Authenticate(),
    );
  }
}
