
import 'package:bloc/bloc.dart';
import '../state/AuthenicationState.dart';
import '../event/AuthenticationEvent.dart';


class AuthenticationBloc extends Bloc< AuthenticationEvent,  AuthenticationState > {

  @override
  AuthenticationState get initialState => new AuthenticationStateInitializing();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if ( event == AuthenticationEvent.Initalize ){
      yield new AuthenticationStateLoading();
    }
    else if ( event == AuthenticationEvent.LoggedIn ){
      yield new AuthenticationStateLoading();
      //..... Need Loading? ....
      await new Future.delayed(Duration(seconds: 2));
      yield new AuthenticationStateAuthorized();
    } 
    else if ( event == AuthenticationEvent.LoggedOut ){
      yield AuthenticationStateLoading();
      //..... Need Loading? .....
      await new Future.delayed(Duration(seconds: 2));
      yield new AuthenticationStateUnauthorized();
    }

  }
}