import 'package:flutter/material.dart';
import 'package:traind_flutter/services/AuthResponse.dart';
import 'package:traind_flutter/services/auth.dart';

class LoaderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoaderState();
  }
}

class LoaderState extends State<LoaderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotoNext();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'images/icon_splash.png',
              color: Colors.white,
              height: 150,
              width: 150,
            ),
            SizedBox(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
                valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(108, 142, 255, 1)),
              ),
              height: 225.0,
              width: 225.0,
            )
          ],
        ),
      ),
    );
  }

  Future gotoNext() async {
    new Future.delayed(new Duration(seconds: 3), () async {
      BaseAuth _auth = new Auth();
      AuthResponse authResponse = await _auth.getCurrentUser(context);
      if (authResponse != null &&
          authResponse.success &&
          authResponse.user != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    });
  }
}
