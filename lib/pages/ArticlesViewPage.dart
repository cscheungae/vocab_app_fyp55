import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';
import 'package:vocab_app_fyp55/bloc/articles_bloc/articles.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ArticlesViewPage extends StatelessWidget {
  final String title;

  ArticlesViewPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ArticlesBloc _articlesBloc = ArticlesBloc();

    return Scaffold(
      appBar: CustomAppBar(title: 'ARTICLES', iconData: Icons.person_pin),
      body: BlocBuilder<ArticlesBloc, ArticlesState> (
        bloc: _articlesBloc,
        builder: (context, state) {
          if (state is ArticlesUninitialized) {
            _articlesBloc.dispatch(LoadArticles(categories: ['A', 'B', 'C']));
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blue,),
            );
          } else if (state is ArticlesLoaded) {
            return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                    child: GestureDetector(
                      onTap: () {print("clicked");_launchURL(context, state.articles[index].url);},
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                              child: Text(
                                state.articles[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Text(state.articles[index].source?.name ?? "Unknown source"),
                            Text(state.articles[index]?.author ?? "Anonymous"),
                            Text(state.articles[index]?.publishedAt ?? ""),
                            Text(state.articles[index]?.content ?? ""),

                          ],
                        )
                      ),
                    ),
                  );
                }
            );
          } else if (state is ArticlesFailure) {
            return Center(
              child: Text(state.error),
            );
          }
          return null;
        },
      ),
    );
  }
}

_launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
      option: new CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: new CustomTabsAnimation.slideIn(),
      extraCustomTabs: <String>[
        // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
        'org.mozilla.firefox',
        // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
        'com.microsoft.emmx',
      ],
    ),
  );
  } catch (e) {
  // An exception is thrown if browser app is not installed on Android device.
  debugPrint(e.toString());
  }
}
