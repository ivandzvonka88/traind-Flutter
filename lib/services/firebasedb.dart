import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traind_flutter/models/User.dart';
import 'package:traind_flutter/utils/Utils.dart';

abstract class FirebaseDB {
  Future<void> createUser(BuildContext context, User data);

  Future<User> getUserData(BuildContext context, String uid);
}

class DB implements FirebaseDB {
  final firestoreInstance = Firestore.instance;

  Future<void> createUser(BuildContext context, User data) async {
    Utils().showProgressDialog(context);
    User user = await getUserData(context, data.uid);
    if (user != null) {
      await firestoreInstance
          .collection('users')
          .document()
          .setData(data.toJson());
    }
    Navigator.pop(context);
  }

  Future<User> getUserData(BuildContext context, String uid) async {
    Utils().showProgressDialog(context);
    QuerySnapshot snapshot = await firestoreInstance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    if (snapshot.documents != null && snapshot.documents.length > 0) {
      Navigator.pop(context);
      return User.fromJsonMap(snapshot.documents[0].data);
    }
    Navigator.pop(context);
    return null;
  }
}
