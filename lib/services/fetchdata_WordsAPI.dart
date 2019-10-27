import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchDataWordsAPI{

  String _word;

  /* Prevent Over-requesting */
  static int Limit = 0;
  static final int LIMIT = 10;

  //Constructor
  FetchDataWordsAPI(String word){ this._word = word; }


  factory FetchDataWordsAPI.fromJson( List<dynamic> json ){
    

  }


  static Future<bool> Request(String word) async{
    
    final String APIAdress = "";
    final String query = word;
    
    var returnedResponse = await http.get(APIAdress);
    if ( returnedResponse.statusCode == 200 ){
      FetchDataWordsAPI fd = FetchDataWordsAPI.fromJson( json.decode(returnedResponse.body));
      return true;
    }
    else { return false; }
  }


}