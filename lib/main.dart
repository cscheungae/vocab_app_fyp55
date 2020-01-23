import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/LeaderBoardPage.dart';
import 'package:vocab_app_fyp55/pages/VocabBanksPage.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/MainPageView.dart';

import 'package:flutter/services.dart';


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
        '/': (context) => MainPageView.instance,
        '/articles': (context) => ArticleViewPage(title: "Article"),
        '/settings': (context) => SettingsPage(),
        '/dictionary': (context) => VocabCardUIPage(),
        '/LeaderBoardPage' : ( context ) => LeaderBoardPage(),
      },
    );
  }
}
