import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/CustomNewsCard.dart';
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
  List<News> newsList;
  int load = 0;

  Future<List<News>> initNewsList() async {
    if (newsList == null )
      newsList = await FetchNews.requestAPIData();
    load += 6;
    return newsList.sublist( load -1);
  }

  loadMoreFromList(){
    setState(() {
      load += 6;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification){
          if ( notification.metrics.pixels == notification.metrics.maxScrollExtent){
              loadMoreFromList();
          }
          return true;
        },
        child: FutureBuilder<List<News>>(
          future: initNewsList(),
          builder: (context, snapshot ){
            return ( ! snapshot.hasData ) ? Text("Still loading") : 
            ListView.builder(
              itemCount: load,
              itemBuilder: (context, position){
                  return CustomNewsCard( newsList[position] );
              },
            );
          }
        ),
      ),

    );
  }
}