import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ArticlesEvent extends Equatable {
  ArticlesEvent([List props = const []]) : super(props);
}

class LoadArticles extends ArticlesEvent {
  final List<String> categories;

  LoadArticles({@required this.categories}): super([categories]);

  @override
  String toString() => 'LoadArticles { categories: ${categories.toString()}';
}
