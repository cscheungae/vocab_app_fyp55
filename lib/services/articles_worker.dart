import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vocab_app_fyp55/bloc/articles_bloc/ArticlesSource.dart';

class ArticlesWorker {
//  final String NEWSAPI_KEY = "072857d78a3a4bb8b0e16443390aac76";
//  final String requestLink = "https://newsapi.org/v2/sources?language=en&apiKey=072857d78a3a4bb8b0e16443390aac76";
  final String requestLink = "https://newsapi.org/v2/top-headlines?country=us&apiKey=072857d78a3a4bb8b0e16443390aac76";

  Future<ArticlesResponse> fetch({@required List<String> categories}) async{
    http.Response rsp = await http.get(requestLink);

    if(rsp.statusCode == 200) {
      print(json.decode(rsp.body));
      return ArticlesResponse.fromJson(json.decode(rsp.body));
    } else {
      throw Exception('Failed to load articles sources');
    }


//    return Future.delayed(Duration(seconds: 4), () => [
//      'Article A',
//      'Article B',
//      'Article C'
//    ]);
  }
}

//sample articles source
const articles = [
  {
    "title": "Gunman kills 20 in rampage at Texas Walmart store",
    "excerpt":
    "A gunman armed with a rifle killed 20 people at a Walmart in El Paso and wounded more than two dozen before being arrested, after the latest U.S. mass shooting sent panicked shoppers fleeing.",
    "media": "Reuter",
    "category": "news"
  },
  {
    "title": "Saeed Malekpour: Web designer escapes life sentence in Iran",
    "excerpt":
    "Saeed Malekpour fled to Canada via a third country while on short-term release from jail.",
    "media": "BBC",
    "category": "news"
  }
];