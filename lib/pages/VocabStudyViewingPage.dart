import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as customTheme;
import '../States/VocabCardState.dart';
import 'package:provider/provider.dart';

class VocabStudyViewingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StatefulBuilder(builder: (context, setState) {
      VocabCardState vocabCard = Provider.of<VocabCardState>(context);
      return Scaffold(
          backgroundColor: customTheme.TOMATO_RED,
          appBar: AppBar(title: Text("prepare")),
          body: Container(
              margin: EdgeInsets.all(20),
              child: CustomScrollView(slivers: <Widget>[
                
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(children: [
                      Spacer(),
                      Chip(
                        label: Text("X to Go"),
                      )
                    ]),
                    VocabCard(vocabCard: vocabCard),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Chip(
                        label: FlatButton(
                          child: Text("Done"),
                          onPressed: () => print("Done."),
                        ),
                      ),
                    )
                  ]),
                )
              ])));
    });
  }
}

class VocabCard extends StatelessWidget {
  VocabCardState vocabCard;
  VocabCard({Key key, this.vocabCard}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StatefulBuilder(builder: (context, setState) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 150, minWidth: MediaQuery.of(context).size.width),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Card(child: Text(vocabCard.name)),
                    Spacer(),
                    Card(child: Text(vocabCard.pos))
                  ],
                ),
              ...List.generate(vocabCard.definitions.length,(i) => Card(child:Text(vocabCard.definitions.elementAt(i)))),
              ...List.generate(vocabCard.examples.length,(i) => Card(child:Text(vocabCard.examples.elementAt(i)))),
              ],
            ),
          ),
        ),
      );
    });
  }
}
