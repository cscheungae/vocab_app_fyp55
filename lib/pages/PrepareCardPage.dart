

import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';

import '../res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';



class PrepareCardPage extends StatefulWidget {
  
  //Constructor
  PrepareCardPage({Key key}) : super(key: key);

  @override
  _PrepareCardPage createState() => _PrepareCardPage();
}



class _PrepareCardPage extends State<PrepareCardPage> with SingleTickerProviderStateMixin {

  //vocabs through UI
  List<Vocab> _readyVocabList;

  ///controller and animation
  AnimationController animeController;
  Animation fadeAnimation;


  @override
  void initState() {
    super.initState();
    animeController = AnimationController( duration: const Duration(milliseconds: 700), vsync: this);
    fadeAnimation = Tween( begin: 0.0, end: 1.0,).animate(animeController);
  }


  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }
  

  /// initialize the Ready Vocab List
  /// Call the database, and check if the word exceed threshold (Ready) or not
  Future<List<Vocab>> initReadyWordsList() async
  {
    if (_readyVocabList == null ){
      //List<User> users = await DatabaseProvider.instance.readAllUser();  
      _readyVocabList = await DatabaseProvider.instance.getReadyVocab() ?? [];
    }
    return _readyVocabList;
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(        
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: RichText(
                maxLines: 3,
                text: TextSpan (
                  children: [
                    TextSpan(
                      text: "Ready word(s) for preparing flashcards:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ]
                ),
              ),
            ),
          ),

          //Ready Word
          FutureBuilder<List<Vocab>>(
            future: initReadyWordsList(),
            builder: ( context, AsyncSnapshot<List<Vocab>> snapshot ){
              if ( snapshot.hasData )
              {
                //No Ready Word
                if ( _readyVocabList.length == 0 ){
                  return Container(
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.hourglass_empty),
                      ),
                      Text("Currently, there is no ready word available"),
                    ],),
                  );
                }
                else return 
                Container(
                  child: Tags(
                    itemCount: _readyVocabList.length,
                    columns: 4,
                    itemBuilder: (position){
                      return ItemTags(
                        index: position,
                        title: _readyVocabList[position].word,
                        textStyle: TextStyle(fontSize: 18),
                        pressEnabled: false,
                      );
                    },
                  )
                );
              } else if ( snapshot.hasError ){
                return Container(child: Text("Problem in loading the words", style: TextStyle(color: Colors.red),),);
              }
              else return Container();
            }
          ),

          //Buttons
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                        color: CustomTheme.TOMATO_RED,
                        child: Text("Back"),
                        onPressed: (){
                          Navigator.pop(context);
                        }
                      ),
                    ),
                    Container (
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                        color: CustomTheme.LIGHT_GREEN,
                        child: Text("Start"),
                        onPressed: (){ 
                          
                        },
                      ),
                    )
              ],),
            ),
          ),
        ],
      ),
    );
  }





}