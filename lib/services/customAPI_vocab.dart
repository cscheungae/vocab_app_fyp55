
import 'dart:convert';
import 'package:vocab_app_fyp55/model/vocabulary.dart';
import 'package:http/http.dart' as http;

class CustomAPIVocab {

  vocabulary vocab;

  //Constructor
  CustomAPIVocab(vocabulary vocab): vocab = vocab;

  //Factory Constructor from json
  factory CustomAPIVocab.fromJson( Map<String, dynamic> json ){
    vocabulary word = new vocabulary(word:"JOJO");
    return new CustomAPIVocab(word);
  }

  //data request from API
  static Future<vocabulary> requestAPIData(String word, {String region = "us"}) async {
    final String url = "localhost:5555/ext/api/vocab?" + "word=" + word + "&region=" + region;
    var returnedResponse = await http.get(url);
    if ( returnedResponse.statusCode == 200 ){
      CustomAPIVocab apiVocab = CustomAPIVocab.fromJson(json.decode(returnedResponse.body));
      return apiVocab.vocab;
    } 
    else return null;
  }
}