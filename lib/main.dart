import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/States/SettingsState.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'FlashVocab',
        theme: CustomTheme.customThemeData,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the HomeScreen
          '/': (context) => HomePage(title: "HOME"),
          '/articles': (context) => ArticleViewPage(title: "Article"),
          '/settings': (context) => SettingsPage(title: "Settings")
        },
      ),
      providers: [
        //inject all necessary States/Services to the child of widget tree.
        ChangeNotifierProvider<SettingsState>.value(value:SettingsState(false,0.5,12))
      ],
    );
  }
}
