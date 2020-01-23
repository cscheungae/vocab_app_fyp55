
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget{

  /// Header of the loading dialog
  final String header;

  /// Constructor of the loading dialog widget
  /// [header] - defaults to loading
  const LoadingDialog({this.header = "Loading" });


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

