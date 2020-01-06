import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/vocabulary.dart';



enum FetchOption {Datamuse, }

class FetchData {

  //Field Members  
  List<vocabulary> FetchedVocabs;

  //Constructor
  FetchData( {fetchedvocabs}  ){this.FetchedVocabs = fetchedvocabs; }

  // Convert Fetched Data from JSON to Words
  factory FetchData.fromJson( List <dynamic> json, [FetchOption option]  ) {   

    List<vocabulary> ResultVocabs = new List<vocabulary>();

    // Return Best 5 Words
    for ( int i = 0; i < 5; i++ )  
    {
      var mapFromJson = json[i]; 
      Map<String, dynamic> mapjson = new Map<String, dynamic>.from( mapFromJson );
      ResultVocabs.add( new vocabulary( word: mapjson['word'])   );
    }

    return FetchData( fetchedvocabs: ResultVocabs );  
  }


  //Async function that makes http request to the API
  //This function ISN't inside the FetchData class!
  static Future< List<vocabulary> > requestAPIData( [String TextQuery = "",] ) async 
  {
    String Input = TextQuery;
    Input = Input.replaceAll(" ", "+");

    String APIAddress = "https://api.datamuse.com/words?ml=" + Input;
    var ReturnedResponse = await http.get(APIAddress);

    if ( ReturnedResponse.statusCode == 200 )  //Success Request
    {
      FetchData fd = FetchData.fromJson(json.decode(ReturnedResponse.body), FetchOption.Datamuse );
      return fd.FetchedVocabs;
    }
    else { return null; }
  }

}









