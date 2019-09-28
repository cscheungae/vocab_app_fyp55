
import 'package:flutter/material.dart';
import 'dart:math';


/* The Main Class of Vocabulary */

enum Wordform { Noun, Verb, Pronoun, Adjective, Adverb, Preposition, Conjunction, Interjection }
List ColorsList = [ Colors.pink[100], Colors.lightGreen[100], Colors.lightBlue[100], Colors.cyan[100], Colors.red[100], Colors.yellow[100], Colors.green[100], Colors.blue[100]  ];

class vocabulary extends ChangeNotifier
{
  String _word;     //The word itself
  Wordform _form;   //form of the word, referred to enum Wordform

  String _meaning;  //Description of the Word
  Color _color;     //Color of the vocabulary Card

  String _imageURL; //URL link of the image

  String getWord() => _word;
  String getMeaning() => _meaning;
  Color getColor() => _color;
  Wordform getWordForm() => _form; 
  String getImageURL() => _imageURL;
  FadeInImage getImage() => FadeInImage(image: NetworkImage(_imageURL), placeholder: AssetImage("assets/FlutterLogo.png"), fit: BoxFit.cover ) ;

  void setImageURL(String url){ this._imageURL = url; notifyListeners(); }

  //Normal Constructor
  vocabulary( { word="",  meaning="", imageURL = "", }  )
  {  
    this._word = word; 
    this._meaning = meaning; 
    this._color  = ColorsList[ Random().nextInt(ColorsList.length -1 ) ];
    this._imageURL = imageURL;
  }

}




