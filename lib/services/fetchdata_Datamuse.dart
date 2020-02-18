import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/vocabulary.dart';



enum FetchOption {Datamuse, }

class FetchData {

  //Field Members  
  List<vocabulary> fetchedVocabs;

  //Constructor
  FetchData( {fetchedvocabs}  ){this.fetchedVocabs = fetchedvocabs; }

  // Convert Fetched Data from JSON to Words
  factory FetchData.fromJson( List <dynamic> json, [FetchOption option]  ) {   

    List<vocabulary> resultVocabs = new List<vocabulary>();

    // Return Best 5 Words
    for ( int i = 0; i < 5; i++ )  
    {
      var mapFromJson = json[i]; 
      Map<String, dynamic> mapjson = new Map<String, dynamic>.from( mapFromJson );
      resultVocabs.add( new vocabulary( word: mapjson['word'])   );
    }

    return FetchData( fetchedvocabs: resultVocabs );  
  }


  //Async function that makes http request to the API
  //This function ISN't inside the FetchData class!
  static Future< List<vocabulary> > requestAPIData( [String textQuery = "",] ) async 
  {
    String input = textQuery;
    input = input.replaceAll(" ", "+");

    String apiAddress = "https://api.datamuse.com/words?ml=" + input;
    var returnedResponse = await http.get(apiAddress);

    if ( returnedResponse.statusCode == 200 )  //Success Request
    {
      FetchData fd = FetchData.fromJson(json.decode(returnedResponse.body), FetchOption.Datamuse );
      return fd.fetchedVocabs;
    }
    else { return null; }
  }

}









