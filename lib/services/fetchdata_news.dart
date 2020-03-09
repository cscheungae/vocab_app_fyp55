import 'package:http/http.dart' as http;
// import 'package:vocab_app_fyp55/services/APIKey.dart';
import 'dart:convert';

class FetchNews {
  FetchNews._();

  List<NewsItem> _newsList = [];
  List<NewsItem> get newsList => _newsList;

  factory FetchNews.fromJson(Map<String, dynamic> json) {
    FetchNews fn = new FetchNews._();
    List<dynamic> newsList = json["sources"];
    for (Map<String, dynamic> newsJson in newsList) {
      fn._newsList.add(new News.fromJson(newsJson));
    }
    return fn;
  }

  static Future<List<News>> requestAPIData({
    String textQuery = "",
  }) async {
    String url = "https://newsapi.org/v2/sources";

    if (textQuery != "") url += "?" + textQuery;

    var returnedResponse = await http.get(
      url,
      // headers: {"X-Api-Key": APIKey.NewsAPI},
    );
    if (returnedResponse.statusCode == 200) {
      FetchNews fn = FetchNews.fromJson(json.decode(returnedResponse.body));
      return fn._newsList;
    } else {
      print("Failure in making NewsAPI request: " +
          returnedResponse.statusCode.toString());
      return null;
    }
  }
}
