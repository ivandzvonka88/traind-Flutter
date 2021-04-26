import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traind_flutter/services/AuthResponse.dart';
import 'package:traind_flutter/services/auth.dart';
import 'package:traind_flutter/utils/Utils.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  BaseAuth _auth = new Auth();

  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(25.0),
          children: <Widget>[
            logoContainer,
            titleContainer,
            divider,
            Container(
              alignment: Alignment.center,
              child: Text(
                'Please choose from below',
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(117, 142, 166, 1)),
              ),
            ),
            createAccountContainer(0),
            createAccountContainer(1),
            createAccountContainer(2),
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Text(
                'Or',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            loginButtonContainer,
          ],
        ),
      ),
    );
  }

  Widget logoContainer = Container(
    child: Image.asset(
      'images/icon_app_title.png',
      height: 75,
    ),
  );
  Widget titleContainer = Container(
    margin: EdgeInsets.only(top: 30.0),
    alignment: Alignment.center,
    child: Text(
      'Create your account',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );

  Widget get divider {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        height: 2.0,
        width: 30.0,
      ),
    );
  }

  Widget createAccountContainer(int type) {
    double margineTop;
    String iconPath;
    String lable;
    switch (type) {
      case 0:
        margineTop = 25.0;
        iconPath = null;
        lable = 'Create account with Email';
        break;
      case 1:
        margineTop = 10.0;
        iconPath = 'images/icon_facebook_round.png';
        lable = 'Create account with Facebook';
        break;
      case 2:
        margineTop = 10.0;
        iconPath = 'images/icon_google_round.png';
        lable = 'Create account with Google';
        break;
    }
    return Container(
      margin: EdgeInsets.only(top: margineTop),
      alignment: Alignment.center,
      child: ButtonTheme(
        minWidth: double.maxFinite,
        height: 60.0,
        child: Material(
          color: Colors.transparent,
          shadowColor: Color.fromRGBO(210, 216, 227, 0.8),
          child: OutlineButton(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                iconPath == null
                    ? Padding(padding: EdgeInsets.all(0))
                    : Image.asset(
                  iconPath,
                  height: 50,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    lable,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(117, 142, 166, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  flex: 1,
                )
              ],
            ),
            borderSide:
            BorderSide(color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            onPressed: () {
              switch (type) {
                case 0:
                  Navigator.of(context).pushNamed('/register');
                  break;
                case 1:
                  signInWithFacebook();
                  break;
                case 2:
                  initGooglrAccount();
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget get loginButtonContainer {
    return Container(
      alignment: Alignment.center,
      child: ButtonTheme(
        minWidth: double.maxFinite,
        height: 60.0,
        child: RaisedButton(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ),
    );
  }

  Future<Null> signInWithFacebook() async {
    AuthResponse authResponse = await _auth.signInWithFacebook(context);
    if (authResponse != null) {
      if (authResponse.success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Utils().showMessageDialog(context, 'Facebook', authResponse.error);
      }
    }
  }

  Future<Null> initGooglrAccount() async {
    googleAccount = await _auth.getSignedInAccount(context, googleSignIn);
    if (googleAccount == null) {
      print('Error Google Login');
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
    }
    AuthResponse authResponse =
        await _auth.signInWithGoogle(context, googleAccount);
    if (authResponse != null) {
      if (authResponse.success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Utils().showMessageDialog(context, 'Google', authResponse.error);
      }
    }
  }
}

enum FormMode { LOGIN, SIGNUP, PHONE }
