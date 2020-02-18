import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/vocabularyDefinition.dart';
import 'package:vocab_app_fyp55/pages/VocabFormPage.dart';
import '../model/vocabulary.dart';
import '../components/DefinitionBlock.dart';
import '../provider/vocabularyBank.dart';
import '../pages/VocabBanksPage.dart';

class VocabDetailsUIPage extends StatefulWidget 
{
  final String title;
  final vocabulary targetWord;

  //Constructor
  VocabDetailsUIPage(vocabulary word, {Key key, String title = "vocabulary", }):
  this.title = title,
  this.targetWord = word, 
  super( key: key);

  @override
  _VocabDetailsUIPage createState() => _VocabDetailsUIPage( this.targetWord );
}



class _VocabDetailsUIPage extends State<VocabDetailsUIPage> with SingleTickerProviderStateMixin
{
  vocabulary targetWord; 
  @override
  _VocabDetailsUIPage( vocabulary vocab ){  this.targetWord = vocab; }

  TabController _defTabController;
  int defIndex = 0;


  @override
  void initState(){ 
    super.initState(); 
    _defTabController =  TabController(length: targetWord.getAllDefinitions().length, vsync: this );
    _defTabController.addListener((){ 
      if (_defTabController.indexIsChanging){ setState(() {
        defIndex = _defTabController.index;
      });}  
    });
  }


  @override
  void dispose(){
    _defTabController.dispose();
    super.dispose();
  }
  
  //Function that alerts if the user should process deletion
  Future<void> confirmDeleteVocab() async{
    showDialog(
      context: context,
      builder: (BuildContext context ){
        return AlertDialog(
          title: new Text("Delete the vocabulary " + targetWord.getWord()),
          content: new Text("Are you sure about that? Such change is irreversible."),
          actions: <Widget>[
            new FlatButton(
              child: Text("No"),
              onPressed: (){
                //Do Nothing
                Navigator.of(context).pop();
              },
            ),

            new FlatButton(
              child: Text("Yes"),
              onPressed: () async { 
                //Do the actual deletion
                await VocabularyBank.instance.deleteVocab(targetWord);
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new VocabCardUIPage() ) );
                setState(() { });
              },
            )
          ]
        );
      }
    );
  }

  

  //Background
  List<Widget> buildBackground(){
    return <Widget>
        [ 
          //BackgroundImage
          Container
          (
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.32,
            child: targetWord.getHeroImage(),
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



  
  //build Definitions
  Widget _buildDefinition( VocabDefinition vd ){
    return Column(children: <Widget>[
        
        //Part Of Speech
        /*
        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text( vd.partOfSpeech , style: TextStyle(color: Colors.blue, fontSize: 18, ),  ),
        ),
        */

       Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Meaning", body: vd.definition ),                        
        ),

        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Example Sentence", body: vd.exampleSentence ),                        
        ), 
        
        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Synonyms", body: ""),                        
        ),

        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Synonyms", body: ""),                        
        ),
    ],);
  }
  



  //Widget Building
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
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                      elevation: 0,
                      title: Text(targetWord.getWord() ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new VocabFormPage(
                               title: "Edit " + targetWord.getWord() , vocab: targetWord,
                             )));
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed:() async {
                            await confirmDeleteVocab();
                          },
                        ),
                      ], 
                    ),
                  ),

                  //Title
                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                    child: Text ( targetWord.getWord(), style: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold, ),  ),
                  ),


                  Text("\n"),


                  //TabBar
                  Container (
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: TabBar(
                      controller: _defTabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.blue,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.blue,
                      indicator: BoxDecoration( 
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      tabs: targetWord.getAllDefinitions().isEmpty ? <Widget>[] :  targetWord.getAllDefinitions().map((context){
                        return Tab(
                          child: Text("DEF", style: TextStyle(fontSize: 14),),
                        );
                      }).toList(),
                    ),
                  ),

                  //Definitions
                  targetWord.getAllDefinitions().isEmpty ? Container() : targetWord.getAllDefinitions().map((context){
                    return _buildDefinition(context);
                  }).toList()[defIndex],
                  
              ],
            ),

        ],),
      ),),

    );   
  }         
                         
}


