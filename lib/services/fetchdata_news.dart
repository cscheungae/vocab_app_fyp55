import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/news.dart';

class FetchNews {

  FetchNews._();

  List<News> _newsList = [];
  List<News> get newsList => _newsList;

  factory FetchNews.fromJson( Map<String, dynamic> json ){
    
    FetchNews fn = new FetchNews._();
    List<dynamic> newsList = json["source"];
    for ( Map<String, String> newsJson in newsList ){
      fn._newsList.add( new News.fromJson(newsJson));
    }
    return fn; 
  }

  
  static Future< List<News> > requestAPIData( {String textQuery = "",} ) async {
    String url = "https://newsapi.org/v2/sources";

    if ( textQuery != "")
      url += "?" + textQuery;

    var returnedResponse = await http.get(url);
    if ( returnedResponse.statusCode == 200 ){
      FetchNews fn = FetchNews.fromJson(json.decode(returnedResponse.body));
      return fn._newsList;
    }
    else { print("Failure in making NewsAPI request"); return null; }
  }


}
