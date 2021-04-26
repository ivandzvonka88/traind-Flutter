import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traind_flutter/models/User.dart';
import 'package:traind_flutter/services/AuthResponse.dart';
import 'package:traind_flutter/services/firebasedb.dart';
import 'package:traind_flutter/utils/Utils.dart';
import 'package:traind_flutter/ws/MyHttpClient.dart';
import 'package:traind_flutter/ws/WSResponse.dart';

abstract class BaseAuth {
  Future<AuthResponse> signInWithEmail(
      BuildContext context, String email, String password);

  Future<AuthResponse> signInWithFacebook(
    BuildContext context,
  );

  Future<GoogleSignInAccount> getSignedInAccount(
      BuildContext context, GoogleSignIn googleSignIn);

  Future<AuthResponse> signInWithGoogle(
      BuildContext context, GoogleSignInAccount googleSignInAccount);

  Future<AuthResponse> signUp(
      BuildContext context, String email, String password);

  Future<AuthResponse> getCurrentUser(BuildContext context);

  Future<void> sendEmailVerification(BuildContext context);

  Future<void> signOut(BuildContext context);

  Future<bool> isEmailVerified(BuildContext context);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResponse> signInWithEmail(
      BuildContext context, String email, String password) async {
    AuthResponse authResponse = new AuthResponse();
    try {
      Utils().showProgressDialog(context);
      FirebaseUser firebaseUser = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser != null) {
        FirebaseDB firebaseDB = new DB();
        User user = await firebaseDB.getUserData(context, firebaseUser.uid);
        if (user != null) {
          authResponse.success = true;
          authResponse.user = user;
          authResponse.error = '';
        }
      }
    } catch (e) {
      print(e);
      authResponse.success = false;
      authResponse.user = null;
      authResponse.error = e.message;
    }
    Navigator.pop(context);
    return authResponse;
  }

  Future<AuthResponse> signInWithFacebook(BuildContext context) async {
    AuthResponse authResponse = new AuthResponse();
    try {
      final facebookLogin = FacebookLogin();
      FacebookLoginResult result =
          await facebookLogin.logInWithReadPermissions(['email']);
      if (result != null &&
          result.status != null &&
          result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        FirebaseUser firebaseUser =
            await _firebaseAuth.signInWithCredential(credential);
        if (firebaseUser != null) {
          FirebaseDB firebaseDB = new DB();
          User user = await firebaseDB.getUserData(context, firebaseUser.uid);
          if (user != null) {
            authResponse.success = true;
            authResponse.user = user;
            authResponse.error = '';
          } else {
            WSResponse wsResponse = await MyHttpClient().get(
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
            if (wsResponse.success) {
              User data = new User();
              data.uid = authResponse.user.uid;
              data.firstName = wsResponse.response[''];
              data.lastName = wsResponse.response[''];
              data.email = wsResponse.response[''];
              data.dob = wsResponse.response[''];
              data.phone = wsResponse.response[''];

              await firebaseDB.createUser(context, data);
              authResponse.success = true;
              authResponse.user = user;
              authResponse.error = '';
            }
          }
        }
      }
    } catch (e) {
      print(e);
      authResponse.success = false;
      authResponse.user = null;
      authResponse.error = e.message;
    }
    return authResponse;
  }

  Future<GoogleSignInAccount> getSignedInAccount(
      BuildContext context, GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future<AuthResponse> signInWithGoogle(
      BuildContext context, GoogleSignInAccount googleSignInAccount) async {
    AuthResponse authResponse = new AuthResponse();
    try {
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      if (googleAuth != null) {
        print(googleAuth.accessToken);
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        FirebaseUser firebaseUser =
            await _firebaseAuth.signInWithCredential(credential);
        if (firebaseUser != null) {
          FirebaseDB firebaseDB = new DB();
          User user = await firebaseDB.getUserData(context, firebaseUser.uid);
          authResponse.success = true;
          authResponse.user = user;
          authResponse.error = '';
        }
      }
    } catch (e) {
      print(e);
      authResponse.success = false;
      authResponse.user = null;
      authResponse.error = e.message;
    }
    return authResponse;
  }

  Future<AuthResponse> signUp(
      BuildContext context, String email, String password) async {
    AuthResponse authResponse = new AuthResponse();
    try {
      Utils().showProgressDialog(context);
      FirebaseUser firebaseUser = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (firebaseUser != null) {
        FirebaseDB firebaseDB = new DB();
        User user = await firebaseDB.getUserData(context, firebaseUser.uid);
        authResponse.success = true;
        authResponse.user = user;
        authResponse.error = '';
      }
    } catch (e) {
      print(e);
      authResponse.success = false;
      authResponse.user = null;
      authResponse.error = e.message;
    }
    Navigator.pop(context);
    return authResponse;
  }

  Future<AuthResponse> getCurrentUser(BuildContext context) async {
    AuthResponse authResponse = new AuthResponse();
    try {
      Utils().showProgressDialog(context);
      FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
      if (firebaseUser != null) {
        FirebaseDB firebaseDB = new DB();
        User user = await firebaseDB.getUserData(context, firebaseUser.uid);
        authResponse.success = true;
        authResponse.user = user;
        authResponse.error = '';
      }
    } catch (e) {
      print(e);
      authResponse.success = false;
      authResponse.user = null;
      authResponse.error = e.message;
    }
    Navigator.pop(context);
    return authResponse;
  }

  Future<void> signOut(BuildContext context) async {
    Utils().showProgressDialog(context);
    await _firebaseAuth.signOut();
    Navigator.pop(context);
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    Utils().showProgressDialog(context);
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
    Navigator.pop(context);
  }

  Future<bool> isEmailVerified(BuildContext context) async {
    Utils().showProgressDialog(context);
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      Navigator.pop(context);
      return user.isEmailVerified;
    }
    Navigator.pop(context);
    return false;
  }
}
