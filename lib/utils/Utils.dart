import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Utils {
  showMessageDialog(BuildContext context, String title, String message,
      {bool cancelable = true}) {
    showDialog(
        context: context,
        barrierDismissible: cancelable,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  showImageWithImageLoader(String path) {
    File f = null;
    if (path != null) {
      File(path);
    }
    if (f != null && f.existsSync()) {
      return Image.file(f);
    } else {
      return CachedNetworkImage(
        imageUrl: path,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      );
    }
  }

  showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CircularProgressIndicator();
        });
  }
}
