
import "dart:math";

import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}


class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {

  ///controller and animation
  AnimationController animeController;
  Animation fadeAnimation;

  ///Random
  final random = new Random();

  ///All vocabs being tested
  List<VocabBundle> vocabBundles = [];
    
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


  Future<void> initQuiz() async {
    List<Vocab> vocabs = await DatabaseProvider.instance.getLearningVocabs();

    //Initialize at most 5 words
    for ( int i = 0; i < 5; i++ ){
      if (vocabs.length == 0 ) return;
      int index = random.nextInt( vocabs.length);
      var vb = await DatabaseProvider.instance.readVocabBundle( vocabs[index].vid );
      vocabBundles.add(vb);
      vocabs.removeAt(index);
    }

    //also load the related word
    for ( var vb in vocabBundles ){
      //Request API
      
    }   
  }

  //Test Question
  Widget buildQuestionPage(){
    return Container();
  }


  //Animation
  Widget buildFadeAnimatedPage( Widget child ){
    if (animeController != null )
      animeController.dispose();
    animeController = new AnimationController( duration: const Duration(milliseconds: 700), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((dur){animeController.forward();});

    return FadeTransition(
      opacity: animeController,
      child: child,
    );
  }


  @override
  Widget build(BuildContext context) {
    return 
    Scaffold (
      body: Column(
        children: <Widget>[
          SafeArea(child: Container(),),
          Text("HELLO"),
        ],
      ),
    );
  }
}