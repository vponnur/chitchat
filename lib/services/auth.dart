import 'package:ChitChat/helpers/helperfunctions.dart';
import 'package:ChitChat/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser);
    } on PlatformException catch (e) {
      if (e.code.contains("Error")) {
        return "ERROR Please provide valid Email & Password.";
      } else {
        return e.code.replaceAll("_", " ");
      }
    } catch (e) {
      return "ErrorMsg :${e.toString()}";
    }
  }

  Future signUpWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on PlatformException catch (error) {
      if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        return "ERROR: Given Email already in use, Please use new one.";
      }
    } catch (e) {}
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {}
  }

  Future signOut() async {
    try {
      return await _auth
          .signOut()
          .then((value) => HelperFunctions.resetAllSP());
    } catch (e) {}
  }
}
