/* a model class containing sentence about the news */
import 'package:vocab_app_fyp55/model/ResponseFormat/HyperSentence.dart';

class WordnikResponse {
  String word;
  List<HyperSentence> hyperSentences;

  WordnikResponse({String word, List<HyperSentence> hyperSentences}) {
    this.word = word;
    this.hyperSentences = hyperSentences;
  }

  factory WordnikResponse.fromJson(Map<String, dynamic> json) => new WordnikResponse(
      word: json['word'],
      hyperSentences: HyperSentence.fromJson(sentencesArray: json['sentences']),
  );
}