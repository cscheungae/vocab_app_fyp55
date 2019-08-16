import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/res/theme.dart';
import '../res/theme.dart';
import 'package:provider/provider.dart';
import '../States/VocabCardState.dart';

class VocabStudyPage extends StatelessWidget {
  String title;
  VocabStudyPage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
        data: customThemeData,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.grey,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: List<Widget>.filled(
                        14,
                        Chip(
                          label: Text("Some Vocab"),
                        )),
                  ),
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                            color: Colors.red,
                            child: FlatButton(
                              child: (Text("Cancel")),
                              onPressed: () => print("Cancelled"),
                            )),
                        Card(
                            color: Colors.green,
                            child: FlatButton(
                              child: Text("Start"),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/viewing'),
                            ))
                      ],
                    ),
                  ))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ));
  }
}
