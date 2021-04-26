import 'package:flutter/material.dart';
import 'package:traind_flutter/pages/auth.dart';
import 'package:traind_flutter/pages/home.dart';
import 'package:traind_flutter/screen/LoaderScreen.dart';
import 'package:traind_flutter/screen/LoginScreen.dart';
import 'package:traind_flutter/screen/RegisterScreen.dart';

class AppRootWidget extends StatefulWidget {
  @override
  AppRootWidgetState createState() => new AppRootWidgetState();
}

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
        primaryColor: new Color(0xFF5b81ff),
        primaryColorDark: new Color(0xFF5b81ff),
        accentColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[300],
        fontFamily: 'CircularStd',
      );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Traind',
      debugShowCheckedModeBanner: false,
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => new LoaderScreen(),
        '/auth': (BuildContext context) => new AuthScreen(),
        '/register': (BuildContext context) => new RegisterScreen(),
        '/login': (context) => new LoginScreen(),
        '/home': (context) => new HomeScreen(),
      },
    );
  }
}
