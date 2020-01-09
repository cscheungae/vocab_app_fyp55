import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/stat.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/state/SettingsState.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  final dbHelper = DatabaseProvider.instance;
//  @override
//  Widget build(BuildContext context) {
//    return
//    MaterialApp(
//      title: 'FlashVocab',
//      theme: CustomTheme.customThemeData,
//      initialRoute: '/',
//      routes: {
//        // When navigating to the "/" route, build the HomeScreen
//        '/': (context) => HomePage(title: "HOME"),
//        '/articles': (context) => ArticleViewPage(title: "Article"),
//        '/settings': (context) => SettingsPage(),
//      },
//    );
//  }
//}

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
        title: Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('insert', style: TextStyle(fontSize: 20),),
              onPressed: () {_insert();},
            ),
            RaisedButton(
              child: Text('query', style: TextStyle(fontSize: 20),),
              onPressed: () {_query();},
            ),
            RaisedButton(
              child: Text('update', style: TextStyle(fontSize: 20),),
              onPressed: () {_update();},
            ),
            RaisedButton(
              child: Text('delete', style: TextStyle(fontSize: 20),),
              onPressed: () {_delete();},
            ),
          ],
        ),
      ),
    );
  }

  // Button to play along with the database
  void _insert() async {
    // row to insert
    Stat stat = Stat(logDate: DateTime.now(), trackingCount: 3, learningCount: 2, maturedCount: 1);
    sid1 = await dbHelper.insertStat(stat);
    print('inserted row id: $sid1');
    stat = Stat(logDate: DateTime.now(), trackingCount: 4, learningCount: 2, maturedCount: 2);
    sid2 = await dbHelper.insertStat(stat);
    print('inserted row id: $sid2');
  }
  void _query() async {
    List<Stat> stats = await dbHelper.readStat(sid1);
    print('query all rows:');
    stats.forEach((row) => print(row));
  }

  void _update() async {
    Stat stat = Stat(sid: 3, logDate: DateTime.now(), trackingCount: 0, learningCount: 0, maturedCount: 0);
    int response = await dbHelper.updateStat(stat);
    print('updated row id: $response');
  }

  void _delete() async {
    int response = await dbHelper.deleteStat(sid1);
    print('deleted rows quantity: $response');
  }
}