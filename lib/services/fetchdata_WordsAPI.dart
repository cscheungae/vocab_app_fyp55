import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/vocabulary.dart';

class FetchDataWordsAPI{

  vocabulary _vocab;
  
  get vocab => _vocab;

  /* Prevent Over-requesting */
  static int Limit = 0;
  static final int LIMIT = 10;

  //Constructor
  FetchDataWordsAPI(vocabulary vocab ){ this._vocab = vocab; }


  factory FetchDataWordsAPI.fromJson( Map<String, dynamic> json ){
    
    String word, meaning, wordForm, sampleSentence;
    List<String> synonyms = [] , antonyms = [];

    if ( json["success"] != "false"){
     
      word = json["word"] ?? "";

      List<dynamic> resultJson = json["results"] ?? const [] ;
      meaning = resultJson[0]["definition"] ?? "" ;
      wordForm = resultJson[0]["partOfSpeech"] ?? "" ;

      List<dynamic> examplesJson = resultJson[0]["examples"] ?? const [];
      sampleSentence = ( examplesJson.isNotEmpty ) ? examplesJson[0] : ""; 

      List<dynamic> synonymsJson = resultJson[0]["synonyms"] ?? const [];
      List<dynamic> antonymsJson = resultJson[0]["antonyms"] ?? const [];

      for ( int i = 0; i < synonymsJson.length; i++ ) synonyms.add(synonymsJson[i]);
      for ( int i = 0; i < antonymsJson.length; i++ ) antonyms.add(antonymsJson[i]);

      return FetchDataWordsAPI( new vocabulary( word: word, meaning: meaning, wordForm: wordForm, sampleSentence: sampleSentence,
                              antonyms: antonyms, synonyms: synonyms));
    }
    else return FetchDataWordsAPI( new vocabulary());
  }


  /* Request From API Online */
  static Future<vocabulary> requestFromAPI(String word) async{

    //Prevent Over-Requesting
    Limit++;
    if ( Limit > LIMIT ) return null;
    
    final String APIAdress = "https://wordsapiv1.p.rapidapi.com/words/";
    final String query = word.toLowerCase();
    
    //Very Dangerous!
    var returnedResponse = await http.get( APIAdress + query,
      headers: { "X-RapidAPI-Key" : "",
                 "X-RapidAPI-Host" : "wordsapiv1.p.rapidapi.com",
               },
    );

    if ( returnedResponse.statusCode == 200 ){
      FetchDataWordsAPI fd = FetchDataWordsAPI.fromJson( json.decode(returnedResponse.body));
      return fd._vocab;
    }
    else { print("Failed! :  " + returnedResponse.statusCode.toString() ); return null; }
  }


}