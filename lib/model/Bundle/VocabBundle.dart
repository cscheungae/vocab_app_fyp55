import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/Bundle/FlashcardBundle.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/Bundle/DefinitionBundle.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';

class VocabBundle
{
  // Field
  int vid;
  String word;
  String imageUrl;
  int wordFreq;
  int trackFreq;
  Status status;
  FlashcardBundle flashcardBundle;
  List<DefinitionBundle> definitionsBundle;

  //Get Image
  Widget getImage(){
    return new CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Image( image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover,),
      fit: BoxFit.cover,
    );
  }


  // Constructor
  VocabBundle({ this.vid, this.word, this.imageUrl, this.wordFreq, this.trackFreq, this.status, this.flashcardBundle, this.definitionsBundle })
  {
    this.vid = this.vid ?? null;
    this.word = this.word ?? "";
    this.imageUrl = this.imageUrl ?? "";
    this.wordFreq = this.wordFreq ?? null;
    this.trackFreq = this.trackFreq ?? null;
    this.status = this.status ?? null;
    this.flashcardBundle = this.flashcardBundle ?? null;
    this.definitionsBundle = this.definitionsBundle ?? null;
  }

  @override
  String toString() {
    return "vocabBundle: vid: $vid, word: $word, imageUrl: $imageUrl, wordFreq: $wordFreq, trackFreq: $trackFreq, status: $status, flashBundle: ${flashcardBundle.toString()}, definitionBundle: $definitionsBundle";
  }
}