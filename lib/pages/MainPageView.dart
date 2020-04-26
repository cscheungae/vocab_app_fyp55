
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

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

  @override
  _MainPageView createState() => _MainPageView();
}


class _MainPageView extends State<MainPageView> {  

  List<Widget> pages = [
    new HomePage(), 
    new StudyPage(), 
    new VocabCardUIPage(), 
    new StatisticsPage(), 
  ];

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



  //Private Function for setting current page
  void changePage( int position ){
    if ( position < 0 || position >= this.pages.length ) return;
    setState(() {
      this.currentPosition = position;
    });
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
          changePage(position);
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
          onTap: (index) async{
            if (this.currentPosition != index ){
              int duration = 250 + 250 * (this.currentPosition - index).abs();
              await pController.animateToPage(index, duration: Duration(milliseconds: duration), curve: Curves.decelerate );
              this.currentPosition = index;
            }
            setState(() {});
          }   
    ),
  );
  }
}