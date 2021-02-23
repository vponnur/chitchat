import 'package:ChitChat/helpers/constants.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/services/auth.dart';
import 'package:ChitChat/services/database.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods _db = DatabaseMethods();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot userInfoSnapshot;

  signInUser(BuildContext context) {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus(); // keyborad always closes once submit
      HelperFunctions.saveUserEmailSP(emailController.text.trim());

      setState(() {
        _isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        if (value.toString().contains("ERROR")) {
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState
              .showSnackBar(showSnackBar(msg: value.toString()));
          HelperFunctions.saveUserLoggedInSP(false);
        } else if (value != null) {
          HelperFunctions.saveUserLoggedInSP(true);
          _db.getUserByUserEmail(emailController.text.trim()).then((value) {
            userInfoSnapshot = value;
            if (userInfoSnapshot != null) {
              HelperFunctions.saveUserNameSP(
                  userInfoSnapshot.documents[0].data[Constants.name]);
              HelperFunctions.saveUserIdSP(
                  userInfoSnapshot.documents[0].data[Constants.id]);
            }
          });

          _scaffoldKey.currentState.showSnackBar(showSnackBar(
              msg: "Welcome back : ${HelperFunctions.getUserName()}"));

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      }).catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarMain(context, signOut: false),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) {
                                bool isValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val);
                                if (val.isEmpty || val.length < 7 || !isValid) {
                                  return "Please provide valid email";
                                }
                                return null;
                              },
                              controller: emailController,
                              style: simpleTextStyle(),
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) => signInUser(context),
                              decoration: textFieldInputDecoration('Email'),
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty || val.length < 7) {
                                  return "password must have min 7 characters";
                                }
                                return null;
                              },
                              controller: passwordController,
                              style: simpleTextStyle(),
                              onFieldSubmitted: (_) => signInUser(context),
                              decoration: textFieldInputDecoration('Password'),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Forgot Password?',
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => signInUser(context),
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC),
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign In',
                            style: simpleTextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'SignIn with Google',
                          style: simpleTextStyle(
                              fontSize: 17, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have account? ",
                            style: simpleTextStyle(fontSize: 17),
                          ),
                          GestureDetector(
                            onTap: widget.toggle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Register now",
                                style: simpleTextStyle(
                                    fontSize: 17, underline: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  getUserName() {}
}
