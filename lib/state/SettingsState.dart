
import 'package:equatable/equatable.dart';

class SettingsState implements Equatable {

  //state value
  bool sendNotification;
  double volume;
  int fontSize;

  
  
  //Constructor
  SettingsState(bool sendNotify, double volume, int fontSize):
  sendNotification = sendNotify,
  volume = volume,
  fontSize = fontSize;

  @override
  List<Object> get props => [sendNotification, volume, fontSize];
}