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

  //Bloc for state management
  AuthenticationBloc authBloc = new AuthenticationBloc();

  //key for input login
  var loginKey = GlobalKey<FormState>();

  //Controller for receiving inputs from input field
  var userNameController = new TextEditingController();
  var passwordController = new TextEditingController();


  @override
  void dispose() {
    authBloc.close();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Widget loginField(String header, TextEditingController controller, {hideValue = false}){
    return Container (
      width: MediaQuery.of(context).size.width * 0.95, 
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),    
        child: Card(
          elevation: 2,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, 
            child: TextFormField(
              controller: controller,
              obscureText: hideValue,
              style: TextStyle(color: Colors.white, ),
              validator: (value) {
                if (value.isEmpty)
                  return header + " not filled, please fill in here";
                else if ( value.length < 8 )
                  return header + " must at least have a length of 8";
                return null;
              }
            ),
          ),
        ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        Center(
          child: Form(
            key: loginKey,
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
              
              Text("\n\n"),
              loginField("Username", userNameController),
              loginField("Password", passwordController, hideValue: true),
              Text("\n\n"),

              RaisedButton(
                child: Text("Login!"),
                color: Colors.green,
                onPressed: (){
                  if (loginKey.currentState.validate() )
                    authBloc.add( AuthenticationEvent.LoggedIn );
                },
              ),

              RaisedButton(
                child: Text("Log out"),
                color: Colors.green,
                onPressed: (){
                  authBloc.add( AuthenticationEvent.LoggedOut );
                },
              ),

            ],),
        ),
      ),
    );
  }

  
}