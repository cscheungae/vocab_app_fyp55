import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  /// type "warn": will show an icon and description "Something went wrong."
  /// type "notAvail": will show an icon and a description with "Currently, not available"
  /// type "server_connection_err" : will show an icon sth. goes wrong.
  /// type "enter anything you wnat": will show the things you type in the type argument

  final String type;

  ErrorAlert(this.type);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (type == "warn") {
      children.addAll([
        Icon(
          Icons.warning,
          color: Colors.yellow,
        ),
        Text(
          "Sorry, something went wrong.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        )
      ]);
    } else if (type == "notAvail") {
      children.addAll([
        Image.asset('assets/empty.png', width: 200, height: 200,),
        SizedBox(height: 10),
        Container(
          width: 300,
          child: Text(
            "Sorry, Sentences will not be available until you have learning words. You may click go to Prepare Page to create learning words.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
        )
      ]);
    } else {
      children.addAll([
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(height: 10),
        Container(
            width: 300,
            child: Text(
              "Error: " + type + " - Please contact the admin for details.",
              textAlign: TextAlign.center,
            )),
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
