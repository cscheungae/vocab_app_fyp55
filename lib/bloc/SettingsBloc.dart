
import 'package:bloc/bloc.dart';
import 'package:vocab_app_fyp55/state/SettingsState.dart';
import '../event/SettingsEvent.dart';

class SettingsBloc extends Bloc< SettingsEvent, SettingsState>{

  SettingsState _settingState = SettingsState(false, 0.5, 12);

  @override
  SettingsState get initialState => _settingState;

  @override
  Stream<SettingsState> mapEventToState(event) async* {
    if ( event is ToggleNotifications ){
      //Do Something
      _settingState = new SettingsState( event.hasNotify, _settingState.volume, _settingState.fontSize);
      yield _settingState;
    }
    else if ( event is ChangeFontSize ){
      //Do Something
      _settingState = new SettingsState( _settingState.sendNotification , _settingState.volume,  event.fontSize);
      yield _settingState;
    }
    else if ( event is ChangeVolume ){
      //Do Something
      _settingState = new SettingsState( _settingState.sendNotification , event.volume, _settingState.fontSize);
      yield _settingState;
    }
  }
}