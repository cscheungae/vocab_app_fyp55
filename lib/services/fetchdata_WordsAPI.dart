import 'package:http/http.dart' as http;
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'dart:convert';
import '../model/vocabulary.dart';
// import 'APIKey.dart';

class FetchDataWordsAPI {
  vocabulary _vocab;

  get vocab => _vocab;

  /* Prevent Over-requesting */
  static int limit = 0;
  static const int LIMIT = 20;

  //Constructor
  FetchDataWordsAPI(vocabulary vocab) {
    this._vocab = vocab;
  }

  factory FetchDataWordsAPI.fromJson(Map<String, dynamic> json) {
    String word, meaning, wordForm, sampleSentence;
    List<String> synonyms = [], antonyms = [];

    if (json["success"] != "false") {
      word = json["word"] ?? "";

      List<dynamic> resultJson = json["results"] ?? const [];
      meaning = resultJson[0]["definition"] ?? "";
      wordForm = resultJson[0]["partOfSpeech"] ?? "";

      List<dynamic> examplesJson = resultJson[0]["examples"] ?? const [];
      sampleSentence = (examplesJson.isNotEmpty) ? examplesJson[0] : "";

      List<dynamic> synonymsJson = resultJson[0]["synonyms"] ?? const [];
      List<dynamic> antonymsJson = resultJson[0]["antonyms"] ?? const [];

      for (int i = 0; i < synonymsJson.length; i++)
        synonyms.add(synonymsJson[i]);
      for (int i = 0; i < antonymsJson.length; i++)
        antonyms.add(antonymsJson[i]);

      return FetchDataWordsAPI(new vocabulary(word: word, defs: [
        new VocabDefinition(
            partOfSpeech: wordForm,
            definition: meaning,
            exampleSentence: sampleSentence)
      ]));
    } else
      return FetchDataWordsAPI(new vocabulary());
  }

  /* Request From API Online */
  static Future<vocabulary> requestFromAPI(String word) async {
    //Prevent Over-Requesting
    limit++;

    if (limit > LIMIT) return null;

    final String APIAdress = "https://wordsapiv1.p.rapidapi.com/words/";

    final String query = word.toLowerCase();

    //Very Dangerous!

    var returnedResponse = await http.get(
      APIAdress + query,
      headers: {
        // "X-RapidAPI-Key": APIKey.WordsAPI,
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
