import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/pages/LeaderBoardPage.dart';
import 'package:vocab_app_fyp55/pages/LoginPage.dart';
import 'package:vocab_app_fyp55/pages/OnboardingScreen.dart';
import 'package:vocab_app_fyp55/pages/RegisterPage.dart';
import 'package:vocab_app_fyp55/pages/VocabBanksPage.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ArticlesViewPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/MainPageView.dart';

import 'package:flutter/services.dart';


void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DatabaseNotifier()),
    ],
    child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  final dbHelper = DatabaseProvider.instance;

  Future<bool> isUserExist(BuildContext context) async {
    List<User> users = await Provider.of<DatabaseNotifier>(context, listen: false).dbHelper.readAllUser();
    debugPrint("users size: ${users.length}");
    if(users.isNotEmpty) return true;
    return false;
  }

  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isUserExist(context),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget widget;
          if(snapshot.hasData) {
            widget =
              MaterialApp(
                title: 'FlashVocab',
                theme: CustomTheme.customThemeData,
                initialRoute: (!!snapshot.data == true) ? '/' : '/register',
                routes: {
                  // When navigating to the "/" route, build the HomeScreen
                  '/': (context) => MainPageView.instance,
                  '/register': (context) => RegisterPage(),
                  '/login': (context) => LoginPage(),
                  '/welcome': (context) => OnboardingScreen(),
                  '/articles': (context) => ArticleViewPage(title: "Article"),
                  '/settings': (context) => SettingsPage(),
                  '/dictionary': (context) => VocabCardUIPage(),
                  '/LeaderBoardPage' : ( context ) => LeaderBoardPage(),
                },
              );
          } else if (snapshot.hasError) {
            widget =
                MaterialApp(
                  title: "Error"
                );
          } else {
            widget =
                Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),]
                );
          }
          return widget;
      },
    );
  }
}