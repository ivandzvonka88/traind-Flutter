import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:traind_flutter/services/AuthResponse.dart';
import 'package:traind_flutter/services/auth.dart';
import 'package:traind_flutter/utils/Utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  BaseAuth _auth = new Auth();

  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(25.0),
            children: <Widget>[
              logoContainer,
              titleContainer,
              emailContainer,
              passwordContainer,
              rememberMeContainer,
              forgotPasswordContainer,
              loginButtonContainer(0),
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(
                  'Or',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              loginButtonContainer(1),
              loginButtonContainer(2),
              registerContainer,
            ],
          ),
        ),
      ),
    );
  }

  Widget logoContainer = Container(
    child: Image.asset(
      'images/icon_app.png',
      height: 60,
    ),
  );
  Widget titleContainer = Container(
    margin: EdgeInsets.only(top: 30.0),
    padding: EdgeInsets.all(20.0),
    child: Text(
      'Login to your\naccount',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  );

  Widget get emailContainer1 {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Material(
        elevation: 0.5,
        shadowColor: Color.fromRGBO(210, 216, 227, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Color.fromRGBO(210, 216, 227, 1.0),
            )),
        child: TextFormField(
          controller: emailController,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.only(
                left: 25.0, top: 20.0, bottom: 20.0, right: 25.0),
            prefixIcon: Icon(
              Icons.person_outline,
              color: Color.fromRGBO(186, 192, 202, 1.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Email';
            } else if (!validator.email(value)) {
              return 'Enter valid Email';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget get emailContainer {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      /*child: Material(
        elevation: 0.5,
        shadowColor: Color.fromRGBO(210, 216, 227, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Color.fromRGBO(210, 216, 227, 1.0),
            )),
        child: TextFormField(
          controller: emailController,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.only(
                left: 25.0, top: 20.0, bottom: 20.0, right: 25.0),
            prefixIcon: Icon(
              Icons.person_outline,
              color: Color.fromRGBO(186, 192, 202, 1.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Email';
            } else if (!validator.email(value)) {
              return 'Enter valid Email';
            }
            return null;
          },
        ),
      ),*/
      child: TextFormField(
        controller: emailController,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
          ),
          contentPadding:
              EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0, right: 25.0),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Color.fromRGBO(186, 192, 202, 1.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Email';
          } else if (!validator.email(value)) {
            return 'Enter valid Email';
          }
          return null;
        },
      ),
    );
  }

  Widget get passwordContainer1 {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Material(
        elevation: 0.5,
        shadowColor: Color.fromRGBO(210, 216, 227, 1.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Color.fromRGBO(210, 216, 227, 1.0),
            )),
        child: TextFormField(
          controller: passwordController,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.only(
                left: 25.0, top: 20.0, bottom: 20.0, right: 25.0),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Color.fromRGBO(186, 192, 202, 1.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter Password';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget get passwordContainer {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: passwordController,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: Color.fromRGBO(117, 142, 166, 1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color: Color.fromRGBO(210, 216, 227, 1.0), width: 1.5),
          ),
          contentPadding:
              EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0, right: 25.0),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Color.fromRGBO(186, 192, 202, 1.0),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Password';
          }
          return null;
        },
      ),
    );
  }

  Widget get rememberMeContainer {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 25.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Text(
            'Remember my account',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Switch(
              value: rememberMe,
              onChanged: (isChecked) {
                setState(() {
                  rememberMe = isChecked;
                });
              })
        ],
      ),
    );
  }

  Widget get forgotPasswordContainer {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
      child: FlatButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget loginButtonContainer(int type) {
    double margineTop = 10.0;
    String iconPath;
    String lable;
    switch (type) {
      case 1:
        margineTop = 10.0;
        iconPath = 'images/icon_facebook_round.png';
        lable = 'Login with Facebook';
        break;
      case 2:
        margineTop = 10.0;
        iconPath = 'images/icon_google_round.png';
        lable = 'Login with Google';
        break;
    }
    if (type == 0) {
      return emailloginButtonContainer;
    }
    return Container(
      margin: EdgeInsets.only(top: margineTop),
      alignment: Alignment.center,
      child: ButtonTheme(
        minWidth: double.maxFinite,
        height: 60.0,
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
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              )
            ],
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            switch (type) {
              case 1:
                signInWithFacebook();
                break;
              case 2:
                initUser();
                break;
            }
          },
        ),
      ),
    );
  }

  Widget get emailloginButtonContainer {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
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
            if (_formKey.currentState.validate()) {
              emailLogin(emailController.text, passwordController.text);
            }
          },
        ),
      ),
    );
  }

  Widget get registerContainer {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          FlatButton(
            child: Text(
              'Create Account',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
          ),
        ],
      ),
    );
  }

  emailLogin(String email, String password) async {
    AuthResponse authResponse =
        await _auth.signInWithEmail(context, email, password);
    if (authResponse != null) {
      if (authResponse.success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Utils().showMessageDialog(context, 'Login', authResponse.error);
      }
    }
  }

  Future<Null> initUser() async {
    googleAccount = await _auth.getSignedInAccount(context, googleSignIn);
    if (googleAccount == null) {
      print('Error Google Login');
    } else {
      await signInWithGoogle();
    }
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
