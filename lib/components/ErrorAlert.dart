import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String message;

  ErrorAlert(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Error in loading: " + message,
              style: TextStyle(color: Colors.red),
            ),
          ],
        )
      ],
    );
  }
}
