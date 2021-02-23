import 'package:ChitChat/views/signIn.dart';
import 'package:ChitChat/views/signUp.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignIn = true;

  void toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSignIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
