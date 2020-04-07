import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocab_app_fyp55/components/CustomExpansionTile.dart';
import 'package:vocab_app_fyp55/components/CustomNewsCard.dart';
import 'package:vocab_app_fyp55/components/ErrorAlert.dart';
import 'package:vocab_app_fyp55/components/LoadingIndicator.dart';
import 'package:vocab_app_fyp55/model/ResponseFormat/WordnikResponse.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/services/fetchdata_sentences.dart';
import 'package:vocab_app_fyp55/state/DatabaseNotifier.dart';
import '../model/ResponseFormat/news.dart';
import '../services/fetchdata_news.dart';


class ReadViewPage extends StatefulWidget {
  ReadViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReadViewPageState createState() => _ReadViewPageState();
}

class _ReadViewPageState extends State<ReadViewPage>
    with SingleTickerProviderStateMixin {
  /// A list of News object containing info of each
  List<NewsItem> newsList;
  /// A list of WordnikResponse
  List<WordnikResponse> wordnikResponsesList;

  /// number of news/ wordnikResponse loaded in the presentation layer
  int newsLoad = 0;
  int wordnikResponseLoad = 0;

  ///Animation
  AnimationController animeController;
  Animation<Offset> slideAnimation;

  /// Tabs
  final List<Tab> tabs = <Tab>[
    Tab(text: 'Articles'),
    Tab(text: 'Sentences'),
  ];

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
      newsList = await FetchNews.requestAPIData(categories: users[0].genres);
      // for debugging when no user is in the database
      /* newsList = await FetchNews.requestAPIData(categories: [
        'entertainment',
        'general'
      ]);  */
    }
    newsLoad = newsList.length;
    return newsList.sublist(newsLoad - 1);
  }

  Future<List<WordnikResponse>> initWordnikResponseList() async {
    if(wordnikResponsesList == null) {
      // TODO::get the user readyvocab - bil
      wordnikResponsesList = await FetchSentences.requestAPIData(words: ["bypass", "encounter"]);
    }
    wordnikResponseLoad = wordnikResponsesList.length;
    return wordnikResponsesList.sublist(wordnikResponseLoad - 1);

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

  Widget buildArticleList() {
    return FutureBuilder<List<NewsItem>>(
        future: initNewsList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<NewsItem>> snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = ListView.builder(
                itemCount: newsLoad,
                itemBuilder: (context, position) {
                  return buildAnimatedCustomNewsCard(position);
                  //return CustomNewsCard(newsList[position]);
                });
          }
          //Error Screen
          else if (snapshot.hasError) widget = new ErrorAlert("articles");
          else widget = new LoadingIndicator();
          return widget;
        });
  }

  Widget buildSentenceList() {
    return FutureBuilder<List<WordnikResponse>>(
      future: initWordnikResponseList(),
      builder: (BuildContext context, AsyncSnapshot<List<WordnikResponse>> snapshot) {
        Widget widget;
        if(snapshot.hasData) {
          widget = ListView.builder(
            itemCount: wordnikResponseLoad,
            itemBuilder: (context, position) {
              return CustomExpansionTile(wordnikResponse: wordnikResponsesList[position]);
            }
          );
        } else if(snapshot.hasError) widget = new ErrorAlert("Sentences");
          else widget = new LoadingIndicator();
        return widget;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(children: [
          buildArticleList(),
          buildSentenceList()
        ]),
      ),
    );
  }
}
