import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/NativePage.dart';
import '../res/theme.dart' as CustomTheme;

import '../pages/VocabBanksPage.dart';
import '../pages/StatisticsPage.dart';
import '../pages/HomePage.dart';
import '../pages/StudyPage.dart';
import '../pages/NativePage.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    Key key,
  }) : super(key: key);

  static int index = 0;

  void _selectIndex(BuildContext context, Widget widget, int index) {
    CustomBottomNavBar.index = index;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: CustomTheme.GREEN,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 25.0),
          title: Text(
            "HOME",
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school, size: 25.0),
          title: Text(
            "STUDY",
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books, size: 25.0),
          title: Text(
            "VOCAB",
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart, size: 25.0),
          title: Text(
            "STATS",
            style: TextStyle(fontSize: 10.0),
          ),
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            _selectIndex(
                context,
                HomePage(
                  title: "HOME Page",
                ),
                index);
            break;
          case 1:
            _selectIndex(context, StudyPage(), index);
            break;
          case 2:
            _selectIndex(
                context,
                VocabCardUIPage(
                  title: "VocabCardUI",
                ),
                index);
            break;
          case 3:
            _selectIndex(context, StatisticsPage(), index);
            break;
        }
      },
    );
  }
}
