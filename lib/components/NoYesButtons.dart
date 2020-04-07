import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as CustomTheme;



Widget buildButton( String leftButtonText, String rightButtonText , Function leftButtonFunc, Function rightButtonFunc ){
    return 
    Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: RaisedButton(
                shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                color: CustomTheme.TOMATO_RED,
                child: Text(leftButtonText),
                onPressed:leftButtonFunc
              ),
            ),
            Container (
              padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: RaisedButton(
                shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                color: CustomTheme.LIGHT_GREEN,
                child: Text(rightButtonText),
                onPressed:rightButtonFunc
              ),
            )
      ],),
    );
  }
