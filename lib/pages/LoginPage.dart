import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/authenicationState.dart';
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
    return Scaffold(
        body: 
        Center(
          child: Column(children: <Widget>[
          
          Text("\n\n\n\nHELLO, user!", style: TextStyle(color: Colors.white),),

          
          BlocBuilder< AuthenticationBloc, AuthenticationState>(
            bloc: authBloc,
            builder: (context, state){
              if ( state is AuthenticationStateInitializing )
                return new Text("Current state is initializing, first time here?", style: TextStyle(color: Colors.white), );
              else if ( state is AuthenticationStateAuthorized )
                return new Text("Current state is authorized, welcome user!", style: TextStyle(color: Colors.white),);
              else if ( state is AuthenticationStateLoading )
                return new Text("Current state is loading, please wait..", style: TextStyle(color: Colors.white),);
              else if ( state is AuthenticationStateUnauthorized )
                return new Text("Current state is unauthorized, hello Stranger!", style: TextStyle(color: Colors.white),);
              else return new Text("You shouldn't see this message!");
            },
          ),
          
          Text("\n\n\n"),

          RaisedButton(
            child: Text("Login!"),
            color: Colors.green,
            onPressed: (){
              print("login");
              authBloc.add( AuthenticationEvent.LoggedIn );
            },
          ),

          RaisedButton(
            child: Text("Log out"),
            color: Colors.green,
            onPressed: (){
              print("Log out");
              authBloc.add( AuthenticationEvent.LoggedOut );
            },
          ),
        ],),
      ),
        
    );
  }

  
}