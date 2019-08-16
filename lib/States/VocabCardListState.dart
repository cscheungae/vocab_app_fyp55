import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vocab_app_fyp55/States/VocabCardState.dart';

class VocabCardListState extends ChangeNotifier{
  //the key should be the name of the vocabCardList
  HashMap<String,List<VocabCardState>> _vocabCardList;
  
  VocabCardListState(HashMap<String,List<VocabCardState>>vocabCardList ) : _vocabCardList = vocabCardList;

  VocabCardListState.emptyInstance() : _vocabCardList = HashMap<String,List<VocabCardState>>();

  get vocabCardList => _vocabCardList ;

  set addVocabCard(VocabCardState vocabCard){
    if(_vocabCardList.containsKey(vocabCard.name)){
      _vocabCardList[vocabCard.name].add(vocabCard);
    } else{
      _vocabCardList[vocabCard.name]=[vocabCard];
    }
    notifyListeners();
  }

  set removeVocabCard(VocabCardState vocabCard){
    if(_vocabCardList.length>0){
      if(_vocabCardList.remove(vocabCard)!=null)
        notifyListeners();
    }
  }

  void sort(){
    _vocabCardList.entries.toList().sort((entry1,entry2)=>entry1.key.compareTo(entry2.key));
    notifyListeners();
  }
}

