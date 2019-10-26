import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;

import '../pages/VocabBanksPage.dart';
import '../pages/HomePage.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({ Key key, this.index }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: CustomTheme.GREEN,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 25.0),
            title: Text("HOME", style: TextStyle(fontSize: 10.0),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: 25.0),
            title: Text("STUDY", style: TextStyle(fontSize: 10.0),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books, size: 25.0),
            title: Text("VOCAB", style: TextStyle(fontSize: 10.0),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart, size: 25.0),
            title: Text("STATS", style: TextStyle(fontSize: 10.0),),
          ),
        ],
        onTap: (index){
          if ( index == 0 )
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => HomePage(title: "HOME Page",) ) );
          else if ( index == 2 )
            Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => VocabCardUIPage(title: "VocabCardUI",) ) ); 
         },
    );
  }
}