import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocab_app_fyp55/state/authenicationState.dart';
import '../bloc/AuthenticationBloc.dart';
import '../event/AuthenticationEvent.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}): super(key: key);

  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>{

  AuthenticationBloc authBloc = new AuthenticationBloc();

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: <Widget>[

        /*
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: authBloc,
          builder: (context, state){
            if ( state is AuthenticationStateInitializing )
              return new Text("Current state is initializing, first time here?");
            else if ( state is AuthenticationStateAuthorized )
              return new Text("Current state is authorized, welcome user!");
            else if ( state is AuthenticationStateLoading )
              return new Text("Current state is loading, please wait..");
            else if ( state is AuthenticationStateUnauthorized )
              return new Text("Current state is unauthorized, hello Stranger!");
            else return new Text("You shouldn't see this message!");
          },
        ),
        */

        RaisedButton(
          child: Text("Press me to Login!"),
          onPressed: (){
            authBloc.add( AuthenticationEvent.LoggedIn );
          },
        ),

        RaisedButton(
          child: Text("Press me to Log out!"),
          onPressed: (){
            authBloc.add( AuthenticationEvent.LoggedOut );
          },
        ),

      ],)
        
    );
  }

  
}