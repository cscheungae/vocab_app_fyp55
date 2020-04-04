import 'package:http/http.dart' as http;
import 'package:vocab_app_fyp55/model/ResponseFormat/WordnikResponse.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';
import 'dart:convert';

class FetchSentences {

  FetchSentences._();

  List<WordnikResponse> _wordnikResponseList = [];
  List<WordnikResponse> get wordnikResponseList => _wordnikResponseList;

  factory FetchSentences.fromJson(response) {
    FetchSentences fn = new FetchSentences._();
    for( int i=0; i<response.length; i++) {
      fn._wordnikResponseList.add( new WordnikResponse.fromJson(response[i]));
    }
    return fn;
  }

  static Future<List<WordnikResponse>> requestAPIData({List<String> words }) async {
    try{
      assert(words != null);

      String url = AddressMiddleWare.address + "/ext/api/sentences";

      // generate the query url
      if(words.isEmpty) {
        throw new Exception("fetchdata_sentences requestData method requires non null parameter");
      } else {
        url += "?";
        for(int i=0; i<words.length; i++) {
          url += "words[]=${words[i]}";
          if(i!=words.length-1)
            url += "&";
        }

        var returnedResponse = await http.get(url);

        if(returnedResponse.statusCode == 200) {
          var response = json.decode(returnedResponse.body);
          FetchSentences fn = FetchSentences.fromJson(response);
          return fn._wordnikResponseList;
        } else {
          throw new Exception("Failure in making Wordnik request: " + returnedResponse.statusCode.toString());
        }
      }
    } catch(e){
      print("Fetch sentences failure: " + e.toString());
      return null;
    }
  }
}