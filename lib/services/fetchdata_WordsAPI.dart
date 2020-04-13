import 'package:http/http.dart' as http;
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'dart:convert';
import 'APIKey.dart';

/// Fetching Vocabularies based on wordsAPI
/// warning(1): currently this is directly fetched through API itself
/// warning(2): This should go obselete once Oxford API is in use
class FetchDataWordsAPI {
  VocabBundle _vocab;
  get vocab => _vocab;

  /* Prevent Over-requesting */
  static int limit = 0;
  static const int LIMIT = 20;

  //Constructor
  FetchDataWordsAPI(this._vocab);

  factory FetchDataWordsAPI.fromJson(Map<String, dynamic> json) {
    String word, meaning, wordForm, sampleSentence;

    if (json["success"] != "false") {
      word = json["word"] ?? "";

      List<dynamic> resultJson = json["results"] ?? const [];
      meaning = resultJson[0]["definition"] ?? "";
      wordForm = resultJson[0]["partOfSpeech"] ?? "";

      List<dynamic> examplesJson = resultJson[0]["examples"] ?? const [];
      sampleSentence = (examplesJson.isNotEmpty) ? examplesJson[0] : "";

      //Word returned
      VocabBundle vb = new VocabBundle(word: word, definitionsBundle: [
        DefinitionBundle(defineText: meaning, pos: wordForm, examplesBundle: [
          ExampleBundle(
            sentence: sampleSentence,
          ),
        ]),
      ]);
      return FetchDataWordsAPI(vb);
    } else
      return null;
  }

  static Future<VocabBundle> requestFromAPI(String word) async {
    //Prevent Over-Requesting
    if (++limit > LIMIT) {
      print("You have spammed the request too much!");
      return null;
    }

    final String apiAdress = "https://wordsapiv1.p.rapidapi.com/words/";
    final String query = word.toLowerCase();

    var returnedResponse = await http.get(
      apiAdress + query,
      headers: {
        "X-RapidAPI-Key": APIKey.WordsAPI,
        "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
      },
    );

    if (returnedResponse.statusCode == 200) {
      FetchDataWordsAPI fd =
          FetchDataWordsAPI.fromJson(json.decode(returnedResponse.body));
      return fd._vocab;
    } else {
      print(
          "Failed WordsAPI Call! :  " + returnedResponse.statusCode.toString());
      return null;
    }
  }
}
