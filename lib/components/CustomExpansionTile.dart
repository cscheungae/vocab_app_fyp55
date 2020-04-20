import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/ResponseFormat/WordnikResponse.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CustomExpansionTile extends StatelessWidget {
  CustomExpansionTile({@required this.wordnikResponse});

  final WordnikResponse wordnikResponse;

  List<Widget> buildExpansionTileBody(BuildContext context) {
    return wordnikResponse.hyperSentences.map((hyperSentence) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.black12,
            textTheme: TextTheme(
              subhead: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white24,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0.5, 1.0)),
                ]),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: RichText(
                            text: TextSpan(
                              text: hyperSentence.text.substring(0, hyperSentence.text.indexOf(wordnikResponse.word)),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: hyperSentence.text.substring(hyperSentence.text.indexOf(wordnikResponse.word), hyperSentence.text.indexOf(wordnikResponse.word) + wordnikResponse.word.length),
                                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),
                                ),
                                TextSpan(
                                  text: hyperSentence.text.substring(hyperSentence.text.indexOf(wordnikResponse.word) + wordnikResponse.word.length),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ]
                            )
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebviewScaffold(
                                              url: hyperSentence.link,
                                              appBar: new AppBar(
                                                title:
                                                    new Text("Explore Sentences"),
                                              ),
                                            )));
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.open_in_browser),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text('Open'),
                                ],
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(wordnikResponse.word.toUpperCase(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        subtitle: Text('verb'.toLowerCase(),
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
        // TODO:: add a divider
        children: buildExpansionTileBody(context));
  }
}
