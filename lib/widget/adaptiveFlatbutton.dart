// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveTextbutton extends StatelessWidget {
  final String text;
  final VoidCallback handler;
  // ignore: use_key_in_widget_constructors
  const AdaptiveTextbutton(this.text, this.handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ))
        : TextButton(
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ));
  }
}
