import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/components/CustomNewsCard.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import '../model/news.dart';
import '../services/fetchdata_news.dart';

class ArticleViewPage extends StatefulWidget {
  ArticleViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ArticleViewPageState createState() => _ArticleViewPageState();
}

class _ArticleViewPageState extends State<ArticleViewPage>
    with SingleTickerProviderStateMixin {
  /// A list of News object containing info of each
  List<NewsItem> newsList;

  /// number of news loaded in the presentation layer
  int load = 0;

  ///Animation
  AnimationController animeController;
  Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: animeController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }

  Future<List<NewsItem>> initNewsList() async {
    if (newsList == null) {
      // get the user articles preference
      List<User> users =
          await Provider.of<DatabaseNotifier>(context, listen: false)
              .dbHelper
              .readAllUser();
      print("number of users genres is " + users[0].genres.length.toString());
      newsList = await FetchNews.requestAPIData(categories: users[0].genres);
    }
    load = newsList.length;
    return newsList.sublist(load - 1);
  }

  //Based on CustomNewsCard, but wrap it with Transition Animation
  Widget buildAnimatedCustomNewsCard(int pos) {
    var item = SlideTransition(
      position: slideAnimation,
      child: CustomNewsCard(newsList[pos]),
    );
    WidgetsBinding.instance.addPostFrameCallback((dur) {
      animeController.forward();
    });
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<NewsItem>>(
          future: initNewsList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<NewsItem>> snapshot) {
            Widget widget;
            if (snapshot.hasData) {
              widget = ListView.builder(
                  itemCount: load,
                  itemBuilder: (context, position) {
                    return buildAnimatedCustomNewsCard(position);
                    //return CustomNewsCard(newsList[position]);
                  });
            }
            //Error Screen
            else if (snapshot.hasError) {
              print(snapshot.error);
              print(snapshot);
              widget = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Error in loading Articles",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )
                ],
              );
            }
            //Loading Screen
            else {
              widget =
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                      width: 60,
                      height: 60,
                    )
                  ],
                ),
              ]);
            }
            return widget;
          }),
    );
  }
}
