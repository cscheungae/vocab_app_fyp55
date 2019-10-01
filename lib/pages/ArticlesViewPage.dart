import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';
import 'package:vocab_app_fyp55/bloc/articles_bloc/articles.dart';

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
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                            child: Text(
                              state.articles[index],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          )
                        ],
                      )
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