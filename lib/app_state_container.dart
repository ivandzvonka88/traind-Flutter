import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traind_flutter/pages/auth.dart';
import 'package:traind_flutter/services/auth.dart';

import 'app_state.dart';

enum AuthType { GOOGLE, EMAIL, FACEBOOK }

class AppStateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  AppStateContainer(
      {@required this.child, this.state, this.auth, this.onSignedIn});

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;
  GoogleSignInAccount googleUser;
  final googleSignIn = new GoogleSignIn();
  FirebaseUser facebookUser;
  final facebookLogin = new FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  FormMode _formMode = FormMode.LOGIN;
  String userId;
  bool _isIos;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      initUser();
    }
  }

  Future initUser() async {
    googleUser = await _ensureLoggedInOnStartUp();
    if (googleUser == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      logIntoFirebase(context, state.type);
    }
  }

  logIntoFirebase(context, AuthType type,
      [String email, String password]) async {
    setState(() {
      state.isLoading = true;
    });
    try {
      switch (type) {
        case AuthType.GOOGLE:
          final GoogleSignIn _googleSignIn = GoogleSignIn();

          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final FirebaseUser user =
              await _auth.signInWithCredential(credential);
          print("signed in " + user.displayName);

          setState(() {
            state.user = user;
            state.type = AuthType.GOOGLE;
            state.isLoading = false;
          });
          break;

        case AuthType.FACEBOOK:
          final FacebookLogin _facebookSignIn = FacebookLogin();

          final FacebookLoginResult facebookUser =
              await _facebookSignIn.logInWithReadPermissions(['email']);

          final AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: facebookUser.accessToken.token);

          final FirebaseUser user =
              await _auth.signInWithCredential(credential);
          print("signed in " + user.displayName);

          setState(() {
            state.user = user;
            state.type = AuthType.FACEBOOK;
            state.isLoading = false;
          });
          break;

        case AuthType.EMAIL:
          setState(() {
            state.errorMessage = "";
            state.isLoading = true;
          });
          String userId = "";
          try {
            if (_formMode == FormMode.LOGIN) {
              final FirebaseUser user = await _auth.signInWithEmailAndPassword(
                  email: email, password: password);

              setState(() {
                state.user = user;
                state.type = AuthType.EMAIL;
                state.isLoading = false;
              });
              break;
            } else if (_formMode == FormMode.SIGNUP) {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final FirebaseUser user =
                  await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

              setState(() {
                state.user = user;
                state.type = AuthType.EMAIL;
                state.isLoading = false;
              });
              break;
            }
          } catch (e) {
            print('Error: $e');
            setState(() {
              setState(() {
                state.isLoading = false;
              });
              if (_isIos) {
                setState(() {
                  state.errorMessage = e.details;
                });
              } else
                setState(() {
                  state.errorMessage = e.message;
                });
            });
          }
          break;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  logout(context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    setState(() {
      state.user = null;
      state.type = null;
    });
    _auth.signOut();
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  Future<dynamic> _ensureLoggedInOnStartUp() async {
    if (state != null && state.type != null) {
      switch (state.type) {
        case AuthType.GOOGLE:
          GoogleSignInAccount user = googleSignIn.currentUser;
          if (user == null) {
            user = await googleSignIn.signInSilently();
          }
          googleUser = user;
          return user;
          break;
        case AuthType.FACEBOOK:
          FacebookAccessToken token = await facebookLogin.currentAccessToken;
          if (token.token == null) {
            //todo redo login process. no silent method.
            return null;
          } else {
            final AuthCredential credential =
                FacebookAuthProvider.getCredential(accessToken: token.token);

            final FirebaseUser user =
                await _auth.signInWithCredential(credential);
            print("signed in " + user.displayName);
            facebookUser = user;
            return user;
          }

          break;
        case AuthType.EMAIL:
          return null;
          break;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
