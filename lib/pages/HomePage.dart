import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/NavigationBlock.dart';
import '../components/CircleStatisticsIndicator.dart';

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
    animeController.forward();
  }

  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: slideAnimation,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          children: <Widget>[
            SafeArea(
              child: Container(),
            ),
            CircleStatisticsIndicator(),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: GestureDetector(
                child: NavigationBlock(
                  title: "Article",
                  body: "jojo",
                  colors: CustomTheme.BLUE_GRADIENT_COLORS,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/articles');
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: NavigationBlock(
                title: "Study",
                body: "hi, I am in love with you",
                colors: CustomTheme.RED_GRADIENT_COLORS,
                direction: NavigationBlockAlignment.RtoL,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: NavigationBlock(
                title: "Prepare",
                body: "love",
                colors: CustomTheme.GREEN_GRADIENT_COLORS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
