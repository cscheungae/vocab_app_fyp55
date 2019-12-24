
import 'package:bloc/bloc.dart';
import '../state/authenicationState.dart';
import '../event/AuthenticationEvent.dart';


class AuthenticationBloc extends Bloc< AuthenticationEvent,  AuthenticationState > {

  @override
  AuthenticationState get initialState => AuthenticationStateInitializing();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if ( event == AuthenticationEvent.Initalize ){
      yield AuthenticationStateLoading();
    }
    else if ( event == AuthenticationEvent.LoggedIn ){
      yield AuthenticationStateLoading();
      //..... Need Loading? ....
      await Future.delayed(Duration(seconds: 2));
      yield AuthenticationStateAuthorized();
    } 
    else if ( event == AuthenticationEvent.LoggedOut ){
      yield AuthenticationStateLoading();
      //..... Need Loading? .....
      await Future.delayed(Duration(seconds: 2));
      yield AuthenticationStateUnauthorized();
    }

  }
}