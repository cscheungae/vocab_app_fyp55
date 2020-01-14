

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'vocabularyDefinition.dart';


/* The Main Class of Vocabulary */

class vocabulary 
{
  //Field
  int _vid;
  String _word;     //The word itself
  String _imageURL; //URL link of the image
  int _frequency;
  int _zipfrequency;
  List<VocabDefinition> _definitions;

  //Getter
  String getWord() => _word;
  String getImageURL() => _imageURL;
  int getVID() => _vid;
  int getZipf() => _zipfrequency;
  int getFrequency() => _frequency;
  List<VocabDefinition> getAllDefinitions() => _definitions;
  VocabDefinition getDefinition({int index = 0}) => _definitions[index];

  Widget getImage(){
    return new CachedNetworkImage(
      imageUrl: _imageURL,
      placeholder: (context, url) => Image( image: AssetImage("assets/FlutterLogo.png"), fit: BoxFit.cover,),
      fit: BoxFit.cover,
    );
  }

  Widget getHeroImage(){
    return new Hero(
      tag: this._word + "HeroTag",
      child: getImage(),
    );
  }

  //Setter
  void setVID(int value){ this._vid = value; }
  void setImageURL(String url){ this._imageURL = url;  }
  void addDefinition( VocabDefinition def ){ this._definitions.add(def); }
  void deleteDefinition(int index){ this._definitions.removeAt(index); }


  //Normal Constructor
  vocabulary( { word="",  imageURL = "", int vid = -1, freq = 0, zipfreq = 0, List<VocabDefinition> defs = const [] })
  {  
    this._word = word; 
    this._imageURL = imageURL;
    this._vid = vid;
    this._frequency = freq;
    this._zipfrequency = zipfreq;
    this._definitions = defs;
  }

  //Constructor, From Json to Dart Map Data
  factory vocabulary.fromJson( Map<String, dynamic> json ) { 
    
    List<VocabDefinition> definitions = [];
    try{
      if ( json["definitions"] != null ){
        for ( Map<String, dynamic> definitionJson in json["definitions"] ){
          definitions.add( VocabDefinition.fromJson(definitionJson) );
        }
      }
    } catch(e){ debugPrint("Exceptions in getting the definitions"); }

    return new vocabulary(
      word: json["name"] ?? "",
      imageURL: json["image"] ?? "",
      zipfreq: json["zipf"] ?? 0,
      freq: json["frequency"] ?? 0,
      vid: json["vid"] ?? -1,
      defs: definitions,
    );
  }
  


  //From Dart Map Data to Json
  Map<String, dynamic> toJson({bool needDef = false }) {
    final Map<String, dynamic> json = {
      "name" : _word,
      "image": _imageURL,
      "frequency": _frequency,
      "zipf" : _zipfrequency,
      "vid" : _vid,
    };

    if ( needDef ){
      List< Map<String, dynamic>> definitionsJson = [];
      for ( VocabDefinition def in _definitions ){
        definitionsJson.add(def.toJson());
      }
      json["definitions"] = definitionsJson;
    }

    return json;
  }



}
