

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'vocabularyDefinition.dart';
import 'flashcard.dart';


/* The Main Class of Vocabulary */

enum Status {
  tracked, learning, matured
}

class vocabulary 
{
  //Field
  int _vid;
  String _word;     //The word itself
  String _imageURL; //URL link of the imageq
  int _frequency; // tracking frequency
  int _zipfrequency;  // word frequency
  List<VocabDefinition> _definitions;
  Status _status;
  Flashcard _flashcard; // includes all properties of flashcard



  //Getter
  String getWord() => _word;
  String getImageURL() => _imageURL;
  int getVID() => _vid;
  int getZipf() => _zipfrequency;
  int getFrequency() => _frequency;
  List<VocabDefinition> getAllDefinitions() => _definitions;
  VocabDefinition getDefinition({int index = 0}) => _definitions[index];
  Status getStatus() => _status;
  Flashcard getFlashcard() => _flashcard;


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
  void setStatus(Status status){this._status = status;}
  void setFlashcard(Flashcard flashcard) {this._flashcard = flashcard;}


  //Normal Constructor
  vocabulary( { word="",  imageURL = "", int vid = -1, freq = 0, zipfreq = 0, List<VocabDefinition> defs = const [], status, flashcard})
  {  
    this._word = word; 
    this._imageURL = imageURL;
    this._vid = vid;
    this._frequency = freq;
    this._zipfrequency = zipfreq;
    this._definitions = defs;
    this._status = status ?? Status.tracked;
    this._flashcard = flashcard ?? null;
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
      vid: json["vid"] ?? -1,
      word: json["name"] ?? "",
      imageURL: json["image"] ?? "",
      zipfreq: json["zipf"] ?? 0,
      freq: json["frequency"] ?? 0,
      defs: definitions,
      status: json["status"] ?? null,
      flashcard: (!!json["vid"]&& !!json["dateLastReviewed"] && !!json["daysBetweenReview"] && !!json["rating"]) ? Flashcard(vid: json["vid"], dateLastReviewed: json["dateLastReviewed"], daysBetweenReview: json["daysBetweenReview"], difficulty: json["difficulty"]): null,
    );
  }
  


  //From Dart Map Data to Json
  Map<String, dynamic> toJson({bool needDef = false}) {
    final Map<String, dynamic> json = {
      "vid" : _vid,
      "name" : _word,
      "image": _imageURL,
      "frequency": _frequency,
      "zipf" : _zipfrequency,
      "status": _status,
    };

    if ( needDef ){
      List< Map<String, dynamic>> definitionsJson = [];
      for ( VocabDefinition def in _definitions ){
        definitionsJson.add(def.toJson());
      }
      json["definitions"] = definitionsJson;
    }

    if (_flashcard != null){
      json["flashcard"] = _flashcard.toJson();
    }
    return json;
  }



}
