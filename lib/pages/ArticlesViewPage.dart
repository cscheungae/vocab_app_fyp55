import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/components/CustomNewsCard.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import '../components/CustomDrawer.dart';
import '../model/news.dart';
import '../services/fetchdata_news.dart';

class ArticleViewPage extends StatefulWidget {
  ArticleViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ArticleViewPageState createState() => _ArticleViewPageState();
}

class _ArticleViewPageState extends State<ArticleViewPage> {
  // out the widget's state here
  List<NewsItem> newsList;
  int load = 0;

  Future<List<NewsItem>> initNewsList() async {
    if (newsList == null) {
      // get the user articles preference
      List<User> users =
          await Provider.of<DatabaseNotifier>(context, listen: false)
              .dbHelper
              .readAllUser();
      newsList = await FetchNews.requestAPIData(categories: users[0].genres);
    }
    load = newsList.length;
    return newsList.sublist(load - 1);
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
                    return CustomNewsCard(newsList[position]);
                  });
            } else if (snapshot.hasError) {
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
            } else {
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
