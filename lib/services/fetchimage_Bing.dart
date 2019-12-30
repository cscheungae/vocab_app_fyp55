import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vocab_app_fyp55/services/APIKey.dart';



class FetchImage 
{
  //Field Members
  String wordQueryURL;

  /* Prevent Over-Pulling of new photos */
  static int _limit = 0;
  static final int _LIMIT = 5;


  //Constructor
  FetchImage(url){this.wordQueryURL = url; }


  factory FetchImage.fromJson( Map<String, dynamic> json ) 
  {
    var valueJson = json["value"] ?? [];
    var firstImageJson = valueJson[0] ?? [];
    String url = firstImageJson["contentUrl"] ?? "";

    return FetchImage(url);
  }


  //Update The Image by Bing API
  static Future<String> requestImgURL( String word ) async
  {
    //Prevent OverRequesting
    _limit++;
    if ( _limit > _LIMIT ){
      return null;
    } 
    
    final String APIaddress = "https://api.cognitive.microsoft.com/bing/v7.0/images/search" + "?q=";
      
    //Very Dangerous!
    var response = await http.get(APIaddress + word, 
    headers: { "Ocp-Apim-Subscription-Key": APIKey.BingAPI,
               "license" : "ShareCommercially",
    },    
    );
      
    if ( response.statusCode == 200 )
    {
      FetchImage fi = FetchImage.fromJson( json.decode(response.body) );
      return fi.wordQueryURL;
    }
    else {return null;}
  }

}

