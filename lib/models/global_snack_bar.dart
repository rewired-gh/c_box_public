import 'package:flutter/material.dart';

class GlobalSnackBar {
  static show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Noto Sans',
          ),
        ),
        duration: Duration(seconds: 1),
        // backgroundColor: Colors.redAccent,
      ),
    );
  }
}
