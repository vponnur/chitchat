import 'package:ChitChat/helpers/constants.dart';
import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/services/auth.dart';
import 'package:ChitChat/services/database.dart';
import 'package:ChitChat/widgets/commonWidget.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods _db = DatabaseMethods();

  signupUser() {
    if (_formKey.currentState.validate()) {
      Constants.myId = HelperFunctions.getNewUUId();
      Constants.myName = userNameController.text.trim();

      Map<String, Object> userData = {
        'id': Constants.myId,
        'name': Constants.myName,
        'email': emailController.text.trim()
      };

      setState(() {
        _isLoading = true;
      });

      HelperFunctions.saveUserIdSP(Constants.myId);
      HelperFunctions.saveUserNameSP(Constants.myName);
      HelperFunctions.saveUserEmailSP(emailController.text.trim());

      authMethods
          .signUpWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        if (value.toString().contains("ERROR")) {
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState
              .showSnackBar(showSnackBar(msg: value.toString()));
          HelperFunctions.saveUserLoggedInSP(false);
        } else {
          _db.uploadUserInfo(userData);
          HelperFunctions.saveUserLoggedInSP(true);
          _scaffoldKey.currentState
              .showSnackBar(showSnackBar(msg: "Welcome : ${Constants.myName}"));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
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
                                if (val.isEmpty || val.length < 4) {
                                  return "username should have min 4 characters";
                                }
                                return null;
                              },
                              controller: userNameController,
                              style: simpleTextStyle(),
                              keyboardType: TextInputType.text,
                              onFieldSubmitted: (_) => signupUser,
                              decoration: textFieldInputDecoration('Username'),
                            ),
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
                              keyboardType: TextInputType.emailAddress,
                              style: simpleTextStyle(),
                              onFieldSubmitted: (_) => signupUser(),
                              decoration: textFieldInputDecoration('Email'),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                if (val.isEmpty || val.length < 7) {
                                  return "password must have min 7 characters";
                                }
                                return null;
                              },
                              controller: passwordController,
                              style: simpleTextStyle(),
                              onFieldSubmitted: (_) => signupUser(),
                              decoration: textFieldInputDecoration('Password'),
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
                        onTap: signupUser,
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
                            'Sign Up',
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
                          'SignUp with Google',
                          style: simpleTextStyle(
                              fontSize: 17, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have account? ",
                            style: simpleTextStyle(fontSize: 17),
                          ),
                          GestureDetector(
                            onTap: widget.toggle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "SignIn now",
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
}
