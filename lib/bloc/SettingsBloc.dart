
import 'package:bloc/bloc.dart';
import 'package:vocab_app_fyp55/state/SettingsState.dart';
import '../event/SettingsEvent.dart';

class SettingsBloc extends Bloc< SettingsEvent, SettingsState>{
  @override
  SettingsState get initialState => SettingsState(false, 0.5, 12);

  @override
  Stream<SettingsState> mapEventToState(event) async* {
    if ( event is ToggleNotifications ){
      //Do Something
    }
    else if ( event is ChangeFontSize ){
      //Do Something
    }
  }
}