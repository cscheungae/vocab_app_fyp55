import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/state/SettingsState.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/Bundle/VocabBundle.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final dbHelper = DatabaseProvider.instance;
  @override
  Widget build(BuildContext context) {
    return
    MaterialApp(
      title: 'FlashVocab',
      theme: CustomTheme.customThemeData,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the HomeScreen
        '/': (context) => HomePage(title: "HOME"),
        '/articles': (context) => ArticleViewPage(title: "Article"),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

/*
// For testing the sqlite database
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// For testing the sqlite methods call
class MyHomePage extends StatelessWidget {

  // reference to our single class that manages the database
  final dbHelper = DatabaseProvider.instance;
  int sid1;
  int sid2;

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite hi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            RaisedButton(
//              child: Text('insert', style: TextStyle(fontSize: 20),),
//              onPressed: () {
//                _insert();
//              },
//            ),
//            RaisedButton(
//              child: Text('query', style: TextStyle(fontSize: 20),),
//              onPressed: () {
//                _query();
//              },
//            ),
//            RaisedButton(
//              child: Text('update', style: TextStyle(fontSize: 20),),
//              onPressed: () {
//                _update();
//              },
//            ),
//            RaisedButton(
//              child: Text('delete', style: TextStyle(fontSize: 20),),
//              onPressed: () {
//                _delete();
//              },
//            ),
            RaisedButton(
              child: Text('drop databse', style: TextStyle(fontSize: 20),),
              onPressed: () async {
                await dbHelper.dropDatabase();
                //print('drop all tables sucess: $res');
              },
            ),
//            RaisedButton(
//              child: Text('read vocab bundle', style: TextStyle(fontSize: 20),),
//              onPressed: () {
//                _readVocabBundle();
//              }),
              RaisedButton(
                  child: Text('insert vocab', style: TextStyle(fontSize: 20),),
                  onPressed: () {
                    _insert();
                  },
              ),
              RaisedButton(
                child: Text('print all vocabs', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _printAllVocab();
                },
              ),
              RaisedButton(
                child: Text('insert flashcard', style: TextStyle(fontSize: 20),),
                onPressed: ()  {
                  _insertFlashcard();
                },
              ),
              RaisedButton(
                child: Text('read all flashcard', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _readALlFlashcard();
                },
              ),
              RaisedButton(
                child: Text('revise flashcard', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _reviseFlashcard();
                },
              ),
              RaisedButton(
                child: Text('get study flashcards', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _printStudyFlashcard();
                },
              ),
              RaisedButton(
                child: Text('get study vocabs', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _printStudyVocab();
                },
              ),
              RaisedButton(
                child: Text('get time', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _printTime();
                },
              ),
              RaisedButton(
                child: Text('get vocab by word', style: TextStyle(fontSize: 20),),
                onPressed: () {
                  _seacrhVocabID();
                },
              ),
          ],
        ),
      ),
    );
  }



  // Button to play along with the database
//  // TODO:: check Stat
//  void _insert() async {
//    // row to insert
//    Stat stat = Stat(sid: null, logDate: DateTime.now(), trackingCount: 3, learningCount: 2, maturedCount: 1);
//    sid1 = await dbHelper.insertStat(stat);
//    print('inserted row id: $sid1');
//    stat = Stat(sid: null, logDate: DateTime.now(), trackingCount: 4, learningCount: 2, maturedCount: 2);
//    sid2 = await dbHelper.insertStat(stat);
//    print('inserted row id: $sid2');
//  }
//  void _query() async {
//    Stat stat = await dbHelper.readStat(1);
//    print('query all rows:');
//    print(stat);
//  }

  void _readAllStat() async {
    List<Stat> stats = await dbHelper.readAllStat();
    stats.forEach((item) => print(item.toString()));
  }

  void _query() async {
    List<Stat> stats = await dbHelper.getUserStatistics();
    stats.forEach((item) => print(item.toString()));
  }

//  void _update() async {
//    Stat stat = Stat(sid: 2, logDate: DateTime.now(), trackingCount: 0, learningCount: 0, maturedCount: 0);
//    int response = await dbHelper.updateStat(stat);
//    print('updated row id: $response');
//  }
//
//  void _delete() async {
//    int response = await dbHelper.deleteStat(1);
//    print('deleted rows quantity: $response');
//  }


  // TODO:: check vocab
  Future<void> _insert() async {
      Vocab vocab = Vocab(word: "banana", wordFreq: 2, trackFreq: 4, status: Status.learning);
      sid1 = await dbHelper.insertVocab(vocab);
      print('inserted row id: $sid1');
      vocab = Vocab(word: "durian", wordFreq: 3, trackFreq: 2, status: Status.matured);
      sid2 = await dbHelper.insertVocab(vocab);
      print('inserted row id: $sid2');
  }
  // TODO:: readVocab
//  void _query() async {
//    Vocab vocab = await dbHelper.readVocab(sid1);
//    print('query all rows:');
//    print(vocab);
//  }
  // TODO:: get vocab by word
  void _seacrhVocabID() async {
      Vocab vocab = await dbHelper.getVocab("durian");
      print(vocab.toString());
  }

//////  // TODO:: print all the vocab
  void _printAllVocab() async {
    List<Vocab> vocabs = await dbHelper.readAllVocab();
    vocabs.forEach((vocab) => print(vocab.toString()));
  }
    // TODO:: update vocab
//  void _update() async {
//    Vocab vocab = Vocab(vid: sid2,
//        word: "organ",
//        wordFreq: 3,
//        trackFreq: 2,
//        status: Status.tracked);
//    int response = await dbHelper.updateVocab(vocab);
//    print('updated row id: $response');
//  }
    // TODO:: deleteAllVocab
//  void _delete() async {
//    int response = await dbHelper.deleteAllVocab();
//    print('deleted rows quantity: $response');
//  }
//
////  // TODO:: insert definition
//  void _insert() async {
//    Definition definition = Definition(vid: 1, pos: "Noun", defineText: "Testing def");
//    int did1 = await dbHelper.insertDefinition(definition);
//    print('inserted definition id: $did1');
//  }
//  // TODO:: query definition
//  void _query() async {
//    List<Definition> definitions = await dbHelper.readDefinition(1);
//    print('read definition: ');
//    print(definitions);
//  }
//  // TODO:: delete all definition
////  void _delete() async {
////    int response = await dbHelper.deleteAllDefinition();
////    print('deleted rows quantity: $response');
////  }
//  //TODO:: update definition
//    void _update() async {
//      int success = await dbHelper.updateDefinition(Definition(vid: 1, did: 1, pos: 'Noun', defineText: "this is updated definition."));
//      print('update definition success? $success');
//    }
//
//    void _delete() async {
//      int success = await dbHelper.deleteDefinition(1);
//      print('delete definition success? $success');
//    }
//
//   TODO:: insert flashcard
  void _insertFlashcard() async {
    Flashcard flashcard = Flashcard(vid: 1);
    int fid1 = await dbHelper.insertFlashcard(flashcard);
    print('inserted flashcard id: $fid1');
  }
//
////  // TODO:: query flashcard
//  void _query() async {
//    Flashcard flashcard = await dbHelper.readFlashcard(1);
//    print('read flashcard: ');
//    print(flashcard);
//  }
////  // TODO:: delete all flashcard
//////  void _delete() async {
//////    int response = await dbHelper.deleteAllFlashcard();
//////    print('deleted rows quantity: $response');
//////  }
//  //TODO:: update flashcard
//  void _update() async {
//    int success = await dbHelper.updateFlashcard(Flashcard(vid: 1, fid: 1, dateLastReviewed: DateTime.now(), daysBetweenReview: 3, rating: 3));
//    print('update flashcard success? $success');
//  }
    // TODO:: revise flashcard
    void _reviseFlashcard() async {
      Flashcard oldFlashcard = await dbHelper.readFlashcard(1);
      int response = await dbHelper.reviseFlashcard(oldFlashcard, 1.0);
      print('revised flashcard response: $response');
    }
    // TODO:: read all flashcard
    void _readALlFlashcard() async {
      List<Flashcard> flashcards = await dbHelper.readAllFlashcard();
      flashcards.forEach((item) => print(item.toString()));
    }
    // TODO:: get study flashcard
    void _printStudyFlashcard() async {
      List<Flashcard> flashcards = await dbHelper.getStudyFlashcards(1);
      if(flashcards.isEmpty) {print("empty list of flashcards returned");}
      flashcards.forEach((item) => print(item.toString()));
    }
//  // TODO:: delete flashcard
//  void _delete() async {
//    int success = await dbHelper.deleteFlashcard(1);
//    print('delete flashcard success? $success');
//  }

  // TODO:: insert pronunciation
//  void _insert() async {
//    Pronunciation pronunciation= Pronunciation(did: 1, ipa: "empty", audioUrl: "empty");
//    int pid1 = await dbHelper.insertPronunciation(pronunciation);
//    print('inserted pronunciation id: $pid1');
//  }
  // TODO:: query pronunciation
//  void _query() async {
//    List<Pronunciation> pronunciations = await dbHelper.readPronunciation(1);
//    print('read pronunciation: ');
//    print(pronunciations);
//  }
//     TODO:: delete all pronunciation
//  void _delete() async {
//    int response = await dbHelper.deleteAllPronunciation();
//    print('deleted rows quantity: $response');
//  }
//  //TODO:: update pronunciation
//  void _update() async {
//    int success = await dbHelper.updatePronunciation(Pronunciation(did: 1, ipa: "", audioUrl: ""));
//    print('update pronunciation success? $success');
//  }
//  // TODO:: delete pronunciation
//  void _delete() async {
//    int success = await dbHelper.deletePronunciation(1);
//    print('delete pronunciation success? $success');
//  }


//  // TODO:: insert examples
//  void _insert() async {
//    Example example= Example(did: 1, sentence: "empty sentence");
//    int eid1 = await dbHelper.insertExample(example);
//    print('inserted example id: $eid1');
//  }
//  // TODO:: query examples
//  void _query() async {
//    List<Example> examples = await dbHelper.readExample(1);
//    print('read pronunciation: ');
//    print(examples);
//  }
//  //  //TODO:: update example
//  void _update() async {
//    int success = await dbHelper.updateExample(Example(eid: 1, did: 1, sentence: "sentence"));
//    print('update example success? $success');
//  }
//    // TODO:: delete all examples
////  void _delete() async {
////    int response = await dbHelper.deleteAllExample();
////    print('deleted rows quantity: $response');
////  }
//
////  // TODO:: delete example
//  void _delete() async {
//    int success = await dbHelper.deleteExample(1);
//    print('delete example success? $success');
//  }

//  // TODO:: read vocab bundle of a word
//  void _readVocabBundle() async {
//    VocabBundle vocabBundle = await dbHelper.readVocabBundle(1);
//    print('read ocab bundle success: ' + vocabBundle.toString());
//  }

//   TODO:: get Study Vocab
    void _printStudyVocab() async {
      List<VocabBundle> vocabBundles = await dbHelper.getStudyVocabs(1);
      vocabBundles.forEach((item) => print(item.toString()));
    }

    // TODO:: get time
    void _printTime() async {
      String time = await dbHelper.getTime();
      print("time now is: $time");
    }
}
*/