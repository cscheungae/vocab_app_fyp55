
import 'package:flutter/material.dart';

class AddVocabFormController {
  
  var wordPartOfSpeechController = TextEditingController();
  var wordDefinitionController = TextEditingController();
  var wordExampleController1 = TextEditingController();
  var wordExampleController2 = TextEditingController();
  var wordExampleController3 = TextEditingController();


  void dispose(){
    //wordController.dispose();
    wordPartOfSpeechController.dispose();
    wordDefinitionController.dispose();
    wordExampleController1.dispose();
    wordExampleController2.dispose();
    wordExampleController3.dispose();
  }

}