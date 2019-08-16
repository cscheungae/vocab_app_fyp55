import 'dart:async';
import 'package:flutter/widgets.dart';

class VocabCardState extends ChangeNotifier{
  String _name;
  String _pos;
  List<String> _definitions;
  List<String> _examples;

  VocabCardState(String name,String pos,List<String> definitions,List<String> examples):
    _name=name,_pos=pos,_definitions=definitions,_examples=examples;

  get name=>_name;
  set setName( String  value){
    _name=value;
    notifyListeners();
  }

  get pos=>_pos;
  set setpos( String  value){
    _pos=value;
    notifyListeners();
  }

  List<String> get definitions=>_definitions;
  void addDefinitions(String value){
    _definitions.add(value);
    notifyListeners();
  }
  void removeDefinitions(String value){
    _definitions.remove(value);
    notifyListeners();
  }

  get examples=>_examples;
  void addExamples(String value){
    _examples.add(value);
    notifyListeners();
  }
  void removeExamples(String value){
    _examples.remove(value);
    notifyListeners();
  }

}