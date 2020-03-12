
/* This page is used for debug purpose only */
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vocab_app_fyp55/model/user.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';

class DebugPage extends StatefulWidget {
  
  DebugPage({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DebugPage();
  }
}

class _DebugPage extends State<DebugPage>{

  TextEditingController _prepareController;

  void initState() {
    super.initState();
    _prepareController = TextEditingController();
  }

  void dispose() {
    _prepareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body: Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        SafeArea(child: Container( height: MediaQuery.of(context).size.height * 0.15 )),
    
        RaisedButton(
          textColor: Colors.white,
          child: Text("Create a User without database opened"),
          onPressed: () async {
            // when success create a user instance and store it in the flutter sqlite
            try {
              var noOfUsers = (await DatabaseProvider.instance.readAllUser()).length;
              if ( noOfUsers != 0 ){
                debugPrint("user already exists"); return;
              }

              await DatabaseProvider.instance.insertUser( new User(uid: 999999, name: "debugAccount", password: "debugAccount" ));
              var user = (await DatabaseProvider.instance.readAllUser())[0];  
              user.setTrackThres(1);
              user.setWordFreqThres(1);
              user.setRegion("us");
              user.setGenres( [
                "business",
                "entertainment",
                "general",
                "health",
                "science",
                "sports",
                "technology"
              ]);
              await DatabaseProvider.instance.updateUser(user);
              Toast.show("Success!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.white70);
            }
            catch (exception){ debugPrint("DebugPage Error:\n" + exception.toString()); }
        }),

        //Add a Traced Word
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            decoration: InputDecoration(hintText: 'Enter a word to be traced'),
            controller: _prepareController,
            onSubmitted: (String text) async {
              try {
                //TODO: The right way to create a new traced word?
                Vocab vocab = new Vocab( word: text,  trackFreq: 1, wordFreq: 1, status: Status.tracked);
                await DatabaseProvider.instance.insertVocab(vocab);

                Toast.show("Traced Successful", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.white70);
              }catch (exception){ debugPrint("DebugPage Error:\n" + exception.toString()); }
            },
          ),
        ),        


    ],));
  }
}