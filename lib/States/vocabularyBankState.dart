import 'package:flutter/foundation.dart';
import 'vocabularyState.dart';

class vocabularyBankState extends ChangeNotifier
{
  List<vocabulary> _vocabList = [];    //whole list of vocabularies, unaltered
  

  get vocabList => _vocabList;

  set vocabList( List<vocabulary> vocablist ){
    _vocabList = vocablist;
    notifyListeners();
  }
  
  void addNewVocabulary( vocabulary vocab )
  {
    _vocabList.add(vocab);
    notifyListeners();
  }  
  
  void debugAddVocabs()
  {
    addNewVocabulary(new vocabulary(word: "Orange") );
    addNewVocabulary(new vocabulary(word: "Apple") );
    addNewVocabulary(new vocabulary(word: "Melon") );
    addNewVocabulary(new vocabulary(word: "Apple1") );
    addNewVocabulary(new vocabulary(word: "Orange1") );
    addNewVocabulary(new vocabulary(word: "Zebra") );
    notifyListeners();
  }


}