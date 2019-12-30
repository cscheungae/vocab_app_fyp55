
import 'package:equatable/equatable.dart';

class SettingsState implements Equatable {

  //state value
  bool _sendNotification;
  double _volume;
  int _fontSize;

  bool get sendNotification => _sendNotification;
  double get volume => _volume;
  int get fontSize => _fontSize;

  
  //Constructor
  SettingsState(bool sendNotify, double volume, int fontSize):
  _sendNotification = sendNotify,
  _volume = volume,
  _fontSize = fontSize;

  @override
  List<Object> get props => [_sendNotification, _volume, _fontSize];
}