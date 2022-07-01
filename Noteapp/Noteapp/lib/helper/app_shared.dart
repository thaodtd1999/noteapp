import 'dart:io';

import 'package:flutter/material.dart';

class AppShared {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool isFirst = true;

  static showMessage(String mess, {bool? isRed}) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
        content: Text(mess),
        backgroundColor: isRed == true ? Colors.red : Colors.black,
        duration: Duration(seconds: isRed == true ? 10 : 1),
      ));
    }
  }

  static showLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
