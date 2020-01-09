
import 'package:flutter/material.dart';

class AddVocabFormController {
  
  //AddVocabFormController(TextEditingController wordController): wordController = wordController;
  //TextEditingController wordController;

  var wordPartOfSpeechController = TextEditingController();
  var wordDefinitionController = TextEditingController();
  var wordSampleSentenceController = TextEditingController();

  var wordSynonymsController = TextEditingController();
  var wordAntonymsController = TextEditingController();

  void dispose(){
    //wordController.dispose();
    wordPartOfSpeechController.dispose();
    wordDefinitionController.dispose();
    wordSampleSentenceController.dispose();
    wordSynonymsController.dispose();
    wordAntonymsController.dispose();
  }

}