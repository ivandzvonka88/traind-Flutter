import 'package:flutter/material.dart';

import '../app_state.dart';
import '../app_state_container.dart';

class SideMenu extends StatefulWidget {
  //final AppState appState;

  //SideMenu({Key key, @required this.appState}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  AppState appState;

  var container;

  //_SideMenuState(@required this.appState) : super();

  @override
  Widget build(BuildContext context) {
    container = AppStateContainer.of(context);
    appState = container.state;

    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text((appState.user.displayName != null)
                ? appState.user.displayName
                : ""),
            accountEmail: new Text(
                (appState.user.email != null) ? appState.user.email : ""),
            currentAccountPicture: new CircleAvatar(
                backgroundImage: NetworkImage((appState.user.photoUrl != null)
                    ? appState.user.photoUrl
                    : "")),
          ),
//          new ListTile(
//            leading: const Icon(Icons.image),
//            title: new Text('Blah'),
//           // onTap: () { _blah(context); },
//          ),
//          new ListTile(
//            leading: const Icon(Icons.image),
//            title: new Text('Blah'),
//           // onTap: () { _blah(context); },
//          ),
//          new ListTile(
//            leading: const Icon(Icons.image),
//            title: new Text('Blah'),
//           // onTap: () { _blah(context); },
//          ),
//          new ListTile(
//            leading: const Icon(Icons.image),
//            title: new Text('Blah'),
//           // onTap: () { _blah(context); },
//          ),
          new ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: new Text('log out'),
            onTap: () {
              container.logout(context);
            },
          )
        ],
      ),
    );
    ;
  }

  void go(String s, BuildContext context) {
    Navigator.pushNamed(context, s);
    print(s);
  }
}
