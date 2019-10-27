import 'package:flutter/material.dart';
import '../States/vocabularyState.dart';
import '../res/theme.dart' as CustomTheme;

import '../States/vocabularyBankState.dart';

class AddNewVocabPage extends StatefulWidget
{
  final String title;
  
  //Constructor
  AddNewVocabPage( {Key key, this.title,}) : super(key: key);

  @override
  _AddNewVocabPage createState() => _AddNewVocabPage();
}




class _AddNewVocabPage extends State <AddNewVocabPage>
with AutomaticKeepAliveClientMixin
{  
  final _wordKey = GlobalKey();
  final _meaningKey = GlobalKey();
  final _wordformKey = GlobalKey();
  final _sampleSentenceKey = GlobalKey();
  final _synonymsKey = GlobalKey();
  final _antonymsKey = GlobalKey();


  final _textWordController = TextEditingController();
  
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose(){
    _textWordController.dispose();
    super.dispose();
  }

  List<Widget> buildBackground(){
    return <Widget>
        [ 
          //BackgroundImage
          Container
          (
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.32,
            child: Image(image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover ), 
          ),

          //Image Filter
          Container
          (
            height: MediaQuery.of(context).size.height * 0.32,
            decoration:BoxDecoration
            (
              color: Colors.white,
              gradient: LinearGradient
              (
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.white,
                  ],
                  stops: [ 0.0,  1.0,]
              )
            ),
          ),

          Padding
          (
            padding: EdgeInsets.fromLTRB(5, 110, 5, 0),
            child:Container
            (
              width: MediaQuery.of(context).size.width * 0.98,
              height: MediaQuery.of(context).size.height * 0.98,
              
              decoration: new BoxDecoration
              ( 
                color: Color.fromRGBO(255, 255, 255, 0.7),
                //color: Colors.blue,
                borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ];      
  }



  Widget buildInputForm( String header, GlobalKey key ){
    return 
    Container (
      height: MediaQuery.of(context).size.height * 0.18, 
      child: Form(
        child: Card(
          elevation: 5,
          child: (
            Row(
              children: <Widget>[
                Text( header + ": ", style: TextStyle(color: Colors.blue, fontSize: 20), ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please enter some text';
                    return null;
                  }
                ),

              ],
            )
          ),
        ),
        key: key,
      )
    );
  }



  @override 
  Widget build( BuildContext context )
  {
     return Scaffold
    (        
      backgroundColor: Colors.white, 
      body: SingleChildScrollView ( child: Stack
      (
        children: List.from(buildBackground())..addAll( <Widget>[ 

          Column(
            children: <Widget>[
              //Appbar
              Container
              (
                height: MediaQuery.of(context).size.height * 0.10,
                child: AppBar
                ( 
                  title: Text( "Create New Word", style: TextStyle(color: Color.fromRGBO(255,255,255,0.8)), ),
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                  elevation: 0, 
                ),
              ),

          

              Form(
                key: _wordKey,
                child: Container
                  (
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    width: MediaQuery.of(context).size.width * 0.90,
                    
                    child: TextFormField
                    (
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                      decoration: InputDecoration(
                        fillColor: Colors.blue,
                        hintText: "Enter the word here",
                        hintStyle: TextStyle(fontSize: 22.0, color: Colors.blue),
                      ),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please enter some text';
                        return null;
                      }
                    ),
                  ),
              ),

              //buildInputForm("Word of Speech", _wordformKey),
              //buildInputForm("Meaning", _meaningKey),
              //buildInputForm("Sample Sentence", _sampleSentenceKey),
              //buildInputForm("Synonyms", _synonymsKey ),
              //buildInputForm("Synonyms", _antonymsKey ),

              Container (
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: RaisedButton(
                  child: Text("Create New Word"),
                  onPressed: (){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  },
                ),
              ),

              
            ],
          ),    
        ],
            
        ),
      ),),

    );
  }
}