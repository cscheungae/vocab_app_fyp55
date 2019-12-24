import 'package:flutter/widgets.dart';


class SettingsState extends ChangeNotifier{
  bool _sendNotification;
  double _volume;
  int _fontSize;
  static List<int> fontSizeOptions = [
    12,24,36,48,1000
  ];


  SettingsState(sendNotification,volume,fontSize):
    _sendNotification=sendNotification,
    _volume=volume,
    _fontSize=fontSize;
  
  get sendNotification => _sendNotification;
  get volume => _volume;
  get fontSize => _fontSize;
  set setSendNotification(bool value){
    _sendNotification=value;
    notifyListeners();
  }
  set setVolume(double value){
    _volume = value;
    notifyListeners();
  }
  set setFontSize(int value){
    _fontSize = value;
    notifyListeners();
  }


}