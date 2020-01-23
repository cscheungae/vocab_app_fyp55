

import 'package:flutter/material.dart';

import '../res/theme.dart' as CustomTheme;

import '../pages/HomePage.dart';
import '../pages/StudyPage.dart';
import '../pages/VocabBanksPage.dart';
import '../pages/StatisticsPage.dart';


class MainPageView extends StatefulWidget {
  //Singleton class
  static final MainPageView _instance = MainPageView._();
  MainPageView._();
  static MainPageView get instance => _instance;

  _MainPageView createState() => _MainPageView();
}


class _MainPageView extends State<MainPageView> {  

  List<Widget> pages = [new HomePage(), new StudyPage(), new VocabCardUIPage(), new StatisticsPage(), ];

  int currentPosition = 0;

  PageController pController;

  @override
  void initState() {
    super.initState();
    pController = new PageController(initialPage: this.currentPosition,);
  }

  @override
  void dispose(){
    pController.dispose();
    super.dispose();
  }

  ///Function for building items within the bottom appbar
  buildBottomNavItem({ IconData iconData = Icons.home, String title = ""  }){
    return 
    BottomNavigationBarItem(
      icon: Icon(iconData, size: 25.0),
      title: Text(title, style: TextStyle(fontSize: 10.0),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, position){
          return this.pages[position];
        },
        controller: pController,
        scrollDirection: Axis.horizontal,
        itemCount: this.pages.length,
        onPageChanged: (position){
          setState(() {
            this.currentPosition = position;
          });
        },

      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: this.currentPosition,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: CustomTheme.GREEN,
          items: [
            buildBottomNavItem(iconData: Icons.home, title: "HOME"),
            buildBottomNavItem(iconData: Icons.school, title: "STUDY"),
            buildBottomNavItem(iconData: Icons.library_books, title: "VOCAB"),
            buildBottomNavItem(iconData: Icons.pie_chart, title: "STATS"),
          ],
          onTap: (index){
            setState(() {
              this.currentPosition = index;
              pController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.decelerate );
            });
          }   
    ),
  );
  }
}