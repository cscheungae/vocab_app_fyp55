import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/VocabStudyPage.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';
import './HomePage.dart';

enum Page { home, study }

const pagesTitle = ["home", "study", "stats"];

class BasePage extends StatefulWidget {
  BasePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // put the widget's state here
  PageController _pageController;
  int _pageIndex = Page.home.index;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.GREY,
      appBar:
          CustomAppBar(title: pagesTitle[_pageIndex], iconData: Icons.person),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            this._pageIndex = newPage;
          });
        },
        children: <Widget>[
          HomePage(title: "home"),
          VocabStudyPage(title: "study")
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
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
            icon: Icon(Icons.book, size: 25.0),
            title: Text("TESTSTUDY", style: TextStyle(fontSize: 10.0)),
          )

//          BottomNavigationBarItem(
//            icon: Icon(Icons.library_books, size: 25.0),
//            title: Text("VOCAB", style: TextStyle(fontSize: 10.0),),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.pie_chart, size: 25.0),
//            title: Text("STATS", style: TextStyle(fontSize: 10.0),),
//          ),
        ],
        onTap: (index) => this._pageController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
      ),
      drawer: Drawer(
        child: Column(
          //Settings
          children: [
            AppBar(
              title: Text("Drawer Navigator"),
              actionsIconTheme: null,
            ),
            Divider(color: Colors.white24),
            ListTile(title: Text("")),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () => Navigator.pushNamed(context, "/settings"),
            )
          ],
        ),
      ),
    );
  }
}
