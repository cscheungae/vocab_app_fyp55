import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:vocab_app_fyp55/bloc/articles_bloc/ArticlesSource.dart';

abstract class ArticlesState extends Equatable {
  ArticlesState([List props = const []]) : super(props);
}

class ArticlesUninitialized extends ArticlesState {
  @override
  String toString() => 'ArticleUninitialized';
}

class ArticlesLoaded extends ArticlesState {
  final List<Article> articles;

  ArticlesLoaded({@required this.articles}) : super([articles]);

  @override
  String toString() => 'ArticlesLoaded';
}

class ArticlesFailure extends ArticlesState {
  final String error;

  ArticlesFailure({@required this.error}): super([error]);

  @override
  String toString() => 'ArticlesFailure { error: $error }';
}