import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  /// type "warn": will show an icon and description "Something went wrong."
  /// type "notAvail": will show an icon and a description with "Currently, not available"
  /// type "enter anything you wnat": will show the things you type in the type argument

  final String type;

  ErrorAlert(this.type);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (type == "warn") {
      children.addAll([
        Icon(Icons.warning, color: Colors.yellow,),
        Text("Sorry, something went wrong", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)
      ]);
    } else if (type == "notAvail") {
      children.addAll([
        Icon(Icons.access_time, color: Colors.yellow,),
        SizedBox(height: 10),
        Text("Currently, not available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)
      ]);
    } else {
      children.addAll([
        Icon(Icons.error, color: Colors.red,),
        SizedBox(height: 10),
        Text("Error in loading, type: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        )
      ],
    );
    ;
  }
}