import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:vocab_app_fyp55/services/articles_worker.dart';
import 'articles.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final ArticlesWorker _articlesWorker = ArticlesWorker();

  @override
  ArticlesState get initialState => ArticlesUninitialized();

  @override
  Stream<ArticlesState> mapEventToState(
    ArticlesEvent event,
  ) async* {
    if (event is LoadArticles) {
      // Try call the API to fetch articles
      // be noticed that the event carries the user's favourite categories
      try {
        List<String> fetchedArticles = await _articlesWorker.fetch(categories: event.categories);
        yield ArticlesLoaded(articles: fetchedArticles);
      } catch (error) {
        yield ArticlesFailure(error: error.toString());
      }
    }
  }
}
