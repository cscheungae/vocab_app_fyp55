
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget{

  final String header;

  const LoadingDialog({Key key, this.header = "Loading" }): super(key:key);

  @override
  Widget build(BuildContext context){
      return AlertDialog(
        title: new Text(header),
        content: CircularProgressIndicator(),
        actions: <Widget>[
          new FlatButton(
            child: Text("Close"),
            onPressed: (){ Navigator.of(context).pop(); }
          ),
        ],
      );
  }
}

