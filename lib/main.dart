import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/components/ErrorAlert.dart';
import 'package:vocab_app_fyp55/components/LoadingIndicator.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/pages/LeaderBoardPage.dart';
import 'package:vocab_app_fyp55/pages/LoginPage.dart';
import 'package:vocab_app_fyp55/pages/OnboardingScreen.dart';
import 'package:vocab_app_fyp55/pages/RegisterPage.dart';
import 'package:vocab_app_fyp55/pages/StatisticsPage.dart';
import 'package:vocab_app_fyp55/pages/VocabBanksPage.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import 'res/theme.dart' as CustomTheme;
import 'pages/HomePage.dart';
import 'pages/ReadViewPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/MainPageView.dart';
import 'pages/StudyPage.dart';

import 'package:flutter/services.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseNotifier()),
      ],
      child: MyApp(),
    ));}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: FutureBuilder<bool>(
        future: Provider.of<DatabaseNotifier>(context, listen: false)
            .dbHelper
            .isUserExist(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = MaterialApp(
              title: 'FlashVocab',
              theme: CustomTheme.customThemeData,
              initialRoute: (!!snapshot.data == false) ? '/' : '/register',
              routes: {
                
                // When navigating to the "/" route, build the HomeScreen
                '/': (context) => MainPageView.instance,
                '/register': (context) => RegisterPage(),
                '/login': (context) => LoginPage(),
                '/welcome': (context) => OnboardingScreen(),
                '/articles': (context) => ReadViewPage(title: "Article"),
                '/settings': (context) => SettingsPage(),
                '/dictionary': (context) => VocabCardUIPage(),
                '/LeaderBoardPage': (context) => LeaderBoardPage(),
                '/statistics': (context) => StatisticsPage(),
                '/study': (context) => StudyPage(),
              },
            );
          } else if (snapshot.hasError)
            widget = new ErrorAlert("Error");
          else
            widget = new LoadingIndicator();
          return widget;
        },
      ),
    );
  }
}
