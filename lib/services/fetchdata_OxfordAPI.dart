

import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FetchDataOxfordAPI {

  VocabBundle _vb;
  get vocab => _vb;

  //Constructor
  FetchDataOxfordAPI(this._vb);

  factory FetchDataOxfordAPI.fromJson( Map<String, dynamic> json ){
    try {
      VocabBundle vb = new VocabBundle(
        word: json["id"],
        definitionsBundle: <DefinitionBundle>[],
      );

      List<dynamic> results = json["results"] ?? [];

      for (var result in results ){
        List<dynamic> lexicalEntries = result["lexicalEntries"] ?? [];      
        for (var leItem in lexicalEntries ?? [] ){
          List<dynamic> senses = leItem["entries"][0]["senses"];
          String pos = leItem["lexicalCategory"]["text"] ?? "";

          List<dynamic> prons = leItem["pronunciations"] ?? []; 

          String soundUrl = "";
          String ipa = "";
          if (prons.isNotEmpty ){
            soundUrl = leItem["pronunciations"][0]["audioFile"] ?? "";
            ipa = leItem["pronunciations"][0]["phoneticSpelling"] ?? "";
          }
          
          for ( var sItem in senses ?? [] ){
            //Definition and pos
            String definition = sItem["definitions"][0];

            PronunciationBundle pb = new PronunciationBundle(audioUrl: soundUrl, ipa: ipa);
            List<PronunciationBundle> pbs = (pb.audioUrl != "" && pb.ipa != "" ) ? [pb] : [];
            DefinitionBundle db = new DefinitionBundle(
              defineText: definition, 
              pos: pos,
              pronunciationsBundle: pbs,
              examplesBundle: [],
            );
            //Example
            for ( var example in sItem["examples"] ?? [] ){
              db.examplesBundle.add(new ExampleBundle(sentence: example["text"]) );
            }
            vb.definitionsBundle.add(db);
          }
        }
      }

      return new FetchDataOxfordAPI(vb);
    } catch (exception){ print("Error in converting Json"); return null; }
  }


  static Future<VocabBundle> requestFromAPI(String word) async {
    final String apiAdress = AddressMiddleWare.address + "/ext/api/vocab?";
    final String query = "word=" + word.toLowerCase() + "&" + "region=" + "gb";

    try {
      var returnedResponse = await http.post( apiAdress + query );
      if (returnedResponse.statusCode == 200 ){
        FetchDataOxfordAPI fd = FetchDataOxfordAPI.fromJson(json.decode(returnedResponse.body));
        return fd._vb;
      }
      else { print("Error: StatusCode " + returnedResponse.statusCode.toString()); return null;  }
    } catch (exception){ print("exception in fetching data"); return null; }
  }
}