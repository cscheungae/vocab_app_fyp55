import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Username is required';
              }
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'Password is required';
              }
            },
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing ... ')));
                  // TODO:: call the middleware api to register
                  try {
                    Map<String, String> headers = {
                      'Content-type': 'application/json'
                    };
                    http.Response response = await http.post(
                        AddressMiddleWare.address + '/user/login',
                        headers: headers,
                        body: jsonEncode({
                          'username': usernameController.text,
                          'password': passwordController.text
                        }));
                    if (response.statusCode == 200) {
                      // get the insertId
                      var data = jsonDecode(response.body)['data'];
                      // TODO:: check the attributes name on the RHS
                      int uid = data[0]['uid'];
                      // TODO:: parse the JSON, get the preference value in seperate
                      var preference = jsonDecode(jsonDecode(data[0]['preference']));
                      int trackThres = preference['trackThres'];
                      int wordFreqThres = preference['wordFreqThres'];
                      String region = preference['region'];
                      List<String> genres = jsonDecode(preference['genres']).cast<String>();
                      // when success create a user instance and store it in the flutter sqlite
                      final dbHelper =
                          Provider.of<DatabaseNotifier>(context, listen: false)
                              .dbHelper;
                      await dbHelper.insertUser(User(
                          uid: uid,
                          name: usernameController.text,
                          password: passwordController.text,
                          trackThres: trackThres,
                          wordFreqThres: wordFreqThres,
                          region: region,
                          genres: genres,
                      ));
                      // Navigate to the welcome route when succeed
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Success'),
                        backgroundColor: Colors.green,
                        onVisible: () =>
                            Navigator.pushReplacementNamed(context, '/'),
                        duration: Duration(milliseconds: 500),
                      ));
                    } else {
                      throw HttpException(response.body);
                    }
                  } on Exception catch (err) {
                    print("Network error: $err");
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Network Error: ${err.toString()}'),
                      backgroundColor: Colors.red,
                    ));
                  }
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid Fields'),
                      backgroundColor: Colors.red));
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
