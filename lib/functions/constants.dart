// ignore_for_file: prefer_const_constructors, constant_identifier_names

import 'package:flutter/material.dart';

const String BASEURL = "http://13.244.216.5:8000";

class AppConstants {
  void alertDialog(
      {required BuildContext context,
      required Widget content,
      required String title,
      required VoidCallback onpress}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content,
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              MaterialButton(
                onPressed: onpress,
                child: Text("submit"),
              ),
            ],
          );
        });
  }
}
