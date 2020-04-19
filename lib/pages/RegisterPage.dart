import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/RegisterForm.dart';

class RegisterPage extends StatelessWidget {
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
              "Register",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            RegisterForm(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Existing user? Login here",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
