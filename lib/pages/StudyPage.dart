

import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';

import '../res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';



class StudyPage extends StatefulWidget {
  
  //Constructor
  StudyPage({Key key}) : super(key: key);

  @override
  _StudyPage createState() => _StudyPage();
}



class _StudyPage extends State<StudyPage> with SingleTickerProviderStateMixin {

  //vocabs through UI
  List<Vocab> _vocabList;

  ///controller and animation
  AnimationController animeController;
  Animation fadeAnimation;

  /// the widget that determines what should be displayed
  Widget mainPage;


  @override
  void initState() {
    super.initState();
    animeController = AnimationController( duration: const Duration(milliseconds: 700), vsync: this);
    fadeAnimation = Tween( begin: 0.0, end: 1.0,).animate(animeController);

    mainPage = buildStartPage();
  }


  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }
  

  //initialize the vocab list 
  Future<List<Vocab>> initVocabCardList( {forceUpdate = false} ) async
  {
    if (_vocabList == null || forceUpdate == true ){
      _vocabList = [];
    }
    return _vocabList;
  }


  //Start Page of The App
  Widget buildStartPage(){
    return 
      Column(
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
                      text: "Words that will be tested are as follows:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ]
                ),
              ),
            ),
          ),

          //Vocabulary
          FutureBuilder<List<Vocab>>(
            future: initVocabCardList(),
            builder: ( context, AsyncSnapshot<List<Vocab>> snapshot ){
              if ( snapshot.hasData )
              {
                //No Vocabulary
                if ( _vocabList.length == 0 ){
                  return Container(
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.hourglass_empty),
                      ),
                      Text("Sorry, It seems like you have no vocabularies ready to be studied"),
                    ],),
                  );
                }
                else return 
                Container(
                  child: Tags(
                    itemCount: _vocabList.length,
                    columns: 4,
                    itemBuilder: (position){
                      return ItemTags(
                        index: position,
                        title: _vocabList[position].word,
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
                          print("You touched me to back!");
                          setState(() {
                            mainPage = buildFadeAnimatedPage(buildStartPage());
                          });
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
                          print("You touched me to start!"); 
                          setState(() {
                            mainPage = buildFadeAnimatedPage(buildStudyVocabPage());
                          });
                        },
                      ),
                    )
              ],),
            ),
          ),
        ],
      );
  }



  Widget buildStudyVocabPage(){
    return SafeArea(child: Text("HELLO", style: TextStyle(color: Colors.white, fontSize: 30, ),));
  }



  //Function for Animated Page
  Widget buildFadeAnimatedPage( Widget child ){
    WidgetsBinding.instance.addPostFrameCallback((dur){animeController.forward();});
    return FadeTransition(
      opacity: animeController,
      child: child,
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(        
        body: mainPage,
    );
  }

}