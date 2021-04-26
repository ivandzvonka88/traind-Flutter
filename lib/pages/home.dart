import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:traind_flutter/screen/LoaderScreen.dart';
import 'package:traind_flutter/widgets/side_menu.dart';

import '../app_state.dart';
import '../app_state_container.dart';
import 'auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int menuIndex;

  @override
  Widget build(BuildContext context) {
    Widget body = _homeView;
    Widget drawer = SideMenu();

    return new Scaffold(
      body: body,
      drawer: drawer,
//      bottomNavigationBar: new BottomNavigationBar(
//          currentIndex: menuIndex,
//          type: BottomNavigationBarType.fixed,
//          onTap: (int index) {
//            setState(() {
//              this.menuIndex = index;
//            });
//          },
//          items: <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//              icon: new ImageIcon(AssetImage('images/icon_profile.png')),
//              title: new Padding(padding: EdgeInsets.all(0)),
//            ),
//            BottomNavigationBarItem(
//              icon: new ImageIcon(AssetImage('images/icon_menu.png')),
//              title: new Padding(padding: EdgeInsets.all(0)),
//            ),
//            BottomNavigationBarItem(
//              icon: new ImageIcon(AssetImage('images/icon_favourite.png')),
//              title: new Padding(padding: EdgeInsets.all(0)),
//            ),
//            BottomNavigationBarItem(
//              icon: new ImageIcon(AssetImage('images/icon_message.png')),
//              title: new Padding(padding: EdgeInsets.all(0)),
//            ),
//          ]),
    );
  }

  /*Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
      return new AuthScreen();
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return CircularProgressIndicator();
  }*/

  Widget get _homeView {
    return _buildBody(context);
  }

  /*Widget get _drawer {
    if (!appState.isLoading && appState.user != null) {
      return new SideMenu();
    } else {
      return null;
    }
  }

  List<Widget> get _actions {
    return (appState.user != null)
        ? <Widget>[
            IconButton(
              icon: Image.asset(
                'images/icon_setting.png',
                height: 25,
              ),
              onPressed: () {},
            ),
          ]
        : <Widget>[Container()];
  }

  Widget get _appBar {
    return new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: new Image.asset(
          'images/icon_app.png',
          height: 150,
        ),
        actions: _actions);
  }*/

  Widget _buildBody(BuildContext context) {
    return Text('Home Page');
  }
}
