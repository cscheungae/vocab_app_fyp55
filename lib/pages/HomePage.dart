import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import 'package:percent_indicator/percent_indicator.dart';
import '../components/CustomAppBar.dart';
import '../components/CustomBottomNavBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // out the widget's state here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "home", iconData: Icons.person ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 255,
                  color: CustomTheme.BLACK,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Text(
                        "progress".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircularPercentIndicator(
                          radius: 155.0,
                          lineWidth: 8.0,
                          animation: true,
                          percent: 0.3,
                          center: Container(
                            padding: const EdgeInsets.all(38.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "39",
                                  style: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "words",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    Text(
                                      "learned",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: CustomTheme.GREEN,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            onPressed: () => debugPrint("More button is clicked"),
                            textColor: CustomTheme.WHITE,
                            color: CustomTheme.GREEN,
                            child: Text(
                                'More',
                                style: TextStyle(fontSize: 14.0)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: CustomTheme.GREEN,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Click to prepare 7 flashcards",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          )
                      ),
                      FlatButton(
                        onPressed: () => debugPrint("green - notification is clicked."),
                        child:  Icon(
                          Icons.close,color: CustomTheme.WHITE, size: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: CustomTheme.TOMATO_RED,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Remind to study 13 flashcards today",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          )
                      ),
                      FlatButton(
                        onPressed: () => debugPrint("red - notification is clicked."),
                        child:  Icon(
                          Icons.close,color: CustomTheme.WHITE, size: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: CustomTheme.BLACK,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Text(
                          "Articles",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 32.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        "\"The more important thing is to read as much as you can, like I did. It will give you an understanding of what makes good writing and it will enlarge your vocabulary.\" - J.K. Rowling",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w200,
                            height: 1.1
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/articles'),
                            textColor: CustomTheme.WHITE,
                            color: CustomTheme.GREEN,
                            child: Text(
                                'Start Reading',
                                style: TextStyle(fontSize: 14.0)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
      backgroundColor: CustomTheme.GREY,// This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        child: Column(

          //Settings
          children:[
            AppBar(title: Text("Drawer Navigator"),actionsIconTheme: null,),
            Divider(color:Colors.white24),
            ListTile(title:Text("")),
            ListTile(
              title:Text("Settings"),
              trailing:Icon(Icons.settings),
              onTap: ()=>Navigator.pushNamed(context,"/settings"),
            )
          ],
        ),
      ),
    );
  }
}
