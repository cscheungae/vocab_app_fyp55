import 'package:http/http.dart' as http;
import 'package:vocab_app_fyp55/services/APIKey.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';
import 'package:vocab_app_fyp55/model/news.dart';

import 'dart:convert';

class FetchNews {
  FetchNews._();

  List<NewsItem> _newsList = [];
  List<NewsItem> get newsList => _newsList;

  factory FetchNews.fromJson(response) {
    FetchNews fn = new FetchNews._();
    for (int i = 0; i < response.length; i++) {
      fn._newsList.add(new NewsItem.fromJson(response[i]));
    }
    return fn;
  }

  // previous request method
//  static Future< List<News> > requestAPIData( {String username, String password, List<String> categories, } ) async {
  static Future<List<NewsItem>> requestAPIData({
    List<String> categories,
  }) async {
    try {
      assert(categories != null);

      String url = AddressMiddleWare.address + "/ext/api/news";

      // generating the query url
      if (categories.isEmpty) {
        return null;
      } else {
        url += "?";
        for (int i = 0; i < categories.length; i++) {
          url += "categories[]=${categories[i]}";
          if (i != categories.length - 1) url += "&";
        }
      }

      var returnedResponse = await http.get(
        url,
        headers: {"X-Api-Key": APIKey.NewsAPI},
      );
      if (returnedResponse.statusCode == 200) {
        var response = json.decode(returnedResponse.body);
        FetchNews fn = FetchNews.fromJson(response);
        return fn._newsList;
      } else {
        print("Failure in making NewsAPI request: " +
            returnedResponse.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("Function Failure - requestAPIData");
      return null;
    }
  }
}
