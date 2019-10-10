import 'package:json_annotation/json_annotation.dart';

// Parsing json result to object
// Reference: https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

@JsonSerializable(explicitToJson: true)
class ArticlesResponse {
  final String status;
  final int totalResults;
  final List<Article> articlesList;

  ArticlesResponse({this.status, this.totalResults, this.articlesList});

  factory ArticlesResponse.fromJson(Map<String, dynamic> json) {
    var  list = json['articles'] as List;
    List<Article> fetchedArticlesList = list.map((i) => Article.fromJson(i)).toList();

    return ArticlesResponse(
      status: json['status'],
      articlesList: fetchedArticlesList,
    );
  }
}

@JsonSerializable()
class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String,
    );
  }
}

@JsonSerializable()
class Source {
  final String id;
  final String name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}


Source _$SourceFromJson(Map<String, dynamic> json) {
  return Source(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}