import 'package:ChitChat/helpers/authenticate.dart';
import 'package:ChitChat/services/auth.dart';
import 'package:ChitChat/views/about.dart';
import 'package:flutter/material.dart';

const int colorLinerBlue = 0xff145C9E;
const int colorLinerBlack = 0xff1F1F1F;

AuthMethods _authMethods = AuthMethods();

Widget appBarMain(BuildContext context,
    {bool signOut = true, String title = "ChitChat"}) {
  title = title == "ChitChat" ? title : "ChitChat - $title";
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Colors.white70),
    ),
    centerTitle: true,
    actions: !signOut
        ? null
        : <Widget>[
            DropdownButtonHideUnderline(
              child: appBarMenu(context),
            ),
          ],
  );
}

DropdownButton appBarMenu(BuildContext context) {
  return DropdownButton(
    icon: Icon(
      Icons.more_vert,
      color: Colors.white,
    ),
    items: [
      DropdownMenuItem(
        value: 'logout',
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Logout'),
                ],
              ),
            ],
          ),
        ),
      ),
      DropdownMenuItem(
        value: 'aboutUs',
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.android),
                  SizedBox(
                    width: 8,
                  ),
                  Text('AboutUs'),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
    onChanged: (ddSelectedValue) {
      if (ddSelectedValue == 'logout') {
        _authMethods.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
      }
      if (ddSelectedValue == 'aboutUs') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutPage(),
            ));
      }
    },
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextStyle(
    {Color color = Colors.white,
    double fontSize = 16.0,
    bool underline = false,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
      color: color,
      fontSize: fontSize,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      fontWeight: fontWeight);
}

//use ERROR in Msg
SnackBar showSnackBar({String msg = ""}) {
  bool isErrorMsg = msg.contains('ERROR');
  msg = isErrorMsg
      ? msg.replaceAll("ERROR", "").substring(0, 1).toUpperCase()
      : msg.substring(0, 1).toUpperCase();
  return SnackBar(
    content: Text(
      msg,
      style: TextStyle(
        color: isErrorMsg ? Colors.red : Colors.white,
      ),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.black45,
  );
}

// //String extenion
// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1)}";
//   }
// }
