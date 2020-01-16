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


  // Constructor
  VocabBundle({ vid, word, imageUrl, wordFreq, trackFreq, status, flashcardBundle, definitionsBundle })
  {
    this.vid = vid ?? null;
    this.word = word ?? "";
    this.imageUrl = imageUrl ?? "";
    this.wordFreq = wordFreq ?? null;
    this.trackFreq = trackFreq ?? null;
    this.status = status ?? null;
    this.flashcardBundle = flashcardBundle ?? null;
    this.definitionsBundle = definitionsBundle ?? null;
  }

  @override
  String toString() {
    return "vocabBundle: vid: $vid, word: $word, imageUrl: $imageUrl, wordFreq: $wordFreq, trackFreq: $trackFreq, status: $status, flashBundle: ${flashcardBundle.toString()}, definitionBundle: $definitionsBundle";
  }
}