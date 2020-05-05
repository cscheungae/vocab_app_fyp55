import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/LoginForm.dart';
import 'package:vocab_app_fyp55/components/RegisterForm.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image(
                    image: AssetImage('assets/logo_green.png'),
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                LoginForm(),
              ],
            ),
          ),
        ));
  }
}
