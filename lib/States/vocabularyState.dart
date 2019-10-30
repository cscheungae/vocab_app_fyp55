
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart';


/* The Main Class of Vocabulary */

class vocabulary extends ChangeNotifier
{
  String _word;     //The word itself
  String _form;   //form of the word, referred to enum Wordform
  String _imageURL; //URL link of the image
  String _meaning;  //Description of the Word
  String _sampleSentence; 

  List<String> _synonyms = [];
  List<String> _antonyms = [];

  String getWord() => _word;
  String getMeaning() => _meaning;
  String getWordForm() => _form; 
  String getImageURL() => _imageURL;
  String getSampleSentence() => _sampleSentence;
  FadeInImage getImage() => FadeInImage(image: NetworkImage(_imageURL), placeholder: AssetImage("assets/FlutterLogo.png"), fit: BoxFit.cover ) ;

  String printSynonyms(){
    String result = "";
    for ( String item in _synonyms)
      result = result + item + ", ";
    return result;
  }

  String printAntonyms(){
    String result = "";
    for ( String item in _antonyms)
      result = result + item + ", ";
    return result;
  }


  void setImageURL(String url){ this._imageURL = url; notifyListeners(); }

  //Normal Constructor
  vocabulary( { word="",  meaning="", imageURL = "", wordForm = "", sampleSentence =" ", 
  synonyms = const <String> [], antonyms = const <String> [] })
  {  
    this._word = word; 
    this._meaning = meaning; 
    this._form = wordForm;
    this._imageURL = imageURL;
    this._sampleSentence =sampleSentence;
    this._antonyms = antonyms;
    this._synonyms =synonyms;
  }

  //From Json to Dart Map Data
  factory vocabulary.fromJson( Map<String, dynamic> json ) => new vocabulary(
    
    word: json["word"] ?? " - null - ",
    meaning: json["meaning"] ?? " - null - " ,
    imageURL: json["imageSource"] ?? "- null -" ,
    sampleSentence: json["sampleSentence"] ?? " - null -",
    wordForm: json["wordForm"] ?? "- null -",

    antonyms: const <String> [],
    synonyms: const <String> [],
  );
  

  //From Dart Map Data to Json
  Map<String, dynamic> toJson() => {
    "word" : _word,
    "meaning" : _meaning,
    "imageSource": _imageURL,
    "sampleSentence" : _sampleSentence,
    "wordForm" : _form,
  };

}



//enum Wordform { Noun, Verb, Pronoun, Adjective, Adverb, Preposition, Conjunction, Interjection, Others }
//String wordFormToString(Wordform f ) => f.toString().split('.').last;