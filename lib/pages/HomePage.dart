import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/PrepareCardPage.dart';
import 'package:vocab_app_fyp55/pages/DebugPage.dart';
import 'package:vocab_app_fyp55/pages/QuizPage.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/NavigationBlock.dart';
import '../components/CircleStatisticsIndicator.dart';

import '../pages/ReadViewPage.dart';
import '../util/Router.dart' as Router;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///controller and animation
  AnimationController animeController;
  Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animeController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: animeController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((dur){animeController.forward();});
    return Scaffold(
      body: SlideTransition(
        position: slideAnimation,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          children: <Widget>[
            
            SafeArea(
              child: CircleStatisticsIndicator(),
            ),
            
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: GestureDetector(
                child: NavigationBlock(
                  title: "Read",
                  body: "Read more articles in here, and explore new vocabularies!",
                  colors: CustomTheme.BLUE_GRADIENT_COLORS,
                ),
                onTap: () {
                  //Navigator.pushNamed(context, '/articles');
                  Navigator.push(context, Router.AnimatedRoute(newWidget: new ReadViewPage()  ));
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: GestureDetector(
                child: NavigationBlock(
                  title: "Prepare",
                  body: "Prepare for new vocabularies",
                  colors: CustomTheme.RED_GRADIENT_COLORS,
                  direction: NavigationBlockAlignment.RtoL,
                ),
                onTap: (){
                  Navigator.push(context, Router.AnimatedRoute(newWidget: new PrepareCardPage()  ));
                },
              ),
            ),

            /*

            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: GestureDetector(
                child: NavigationBlock(
                  title: "Quiz",
                  body: "Want to test your skill? Challenge yourself here!",
                  colors: CustomTheme.GREEN_GRADIENT_COLORS,
                ),
                onTap:(){
                  Navigator.push(context, Router.AnimatedRoute(newWidget: new QuizPage()  ));
                },
              ),
            ),
            */
            

            
            //Debug Use only
            /*
            GestureDetector(
              onTap: (){
                Navigator.push(context, Router.AnimatedRoute(newWidget: new DebugPage()  ));
              },
              child: Container(
                height: 50,
                color: Colors.grey,
                child: Icon(Icons.alarm),
              ),
            ),
            */
            
            
          ],
        ),
      ),
    );
  }
}
