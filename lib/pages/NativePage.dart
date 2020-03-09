import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class NativePage extends StatelessWidget {
  Future<String> getNativeString() async {
    var platform = const MethodChannel('meme');

    String result = await platform.invokeMethod('display');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: getNativeString(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Center(
              child: Text(snapshot.data),
            ),
          );
        } else {
          print(snapshot.data);
          return Container(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
