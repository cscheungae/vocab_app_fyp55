import 'package:http/http.dart' as http;
import 'dart:convert';
import '../States/vocabularyState.dart';

/* Prevent Over-Pulling of new photos */
int Limit = 0;
final int LIMIT = 12;

class FetchImage 
{
  //Field Members
  vocabulary UpdateVocab;

  //Constructor
  FetchImage( fetchedvocabs  ){this.UpdateVocab = fetchedvocabs; }

  factory FetchImage.fromJson( Map<String, dynamic> json, vocabulary vocab ) 
  {
    var FirstImage = json["value"][0];
    vocab.setImageURL( FirstImage["contentUrl"] );
    return FetchImage(vocab);
  }
}


//Update The Image by Bing API
void UpdateImageByAPI( List<vocabulary> vocablist ) async
{
  if ( Limit > LIMIT ) return;  //Prevent OverRequesting

  final String APIaddress = "https://api.cognitive.microsoft.com/bing/v7.0/images/search" + "?q=";
  
  String query = "Word";  
  
  for ( int i = 0; i < vocablist.length; i++ )
  {
    query = vocablist[i].getWord();
    
    var response = await http.get(APIaddress + query, 
    headers: { "Ocp-Apim-Subscription-Key": "b09b679ff49942b6a88c0186f3f8b89c", },    
    );

    if ( true )
    {
      if ( response.statusCode == 200 )
      {
        FetchImage fi = FetchImage.fromJson( json.decode(response.body), vocablist[i] );
        vocablist[i].setImageURL( fi.UpdateVocab.getImageURL() );
        print(fi.UpdateVocab.getImageURL());
      }
    }
  }
}




Future<String> Debug_UpdateImageByAPI( ) async
{
  if ( Limit > LIMIT ) return "Reaching the Limit";  //Prevent OverRequesting

  String query = "iPhone";
  String APIaddress = "https://api.cognitive.microsoft.com/bing/v7.0/images/search" + "?q=";

  var response = await http.get(APIaddress + query, 
  headers: { 
    "Ocp-Apim-Subscription-Key": "b09b679ff49942b6a88c0186f3f8b89c",
    "license" : "Share"  
  },    
  );

  if ( response.statusCode == 200 )
  {
    Limit++;

    var vocab = new vocabulary(word: query);
    FetchImage fi = FetchImage.fromJson( json.decode(response.body), vocab );
    vocab = fi.UpdateVocab;

    print(vocab.getImageURL());
    return "Success! + \n" + vocab.getImageURL() ;
  }
  else { return "Something went wrong + \n" + response.body; }
}