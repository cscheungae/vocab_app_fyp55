
import 'package:flutter/material.dart';
import '../States/vocabularyState.dart';
import '../components/DefinitionBlock.dart';
import '../res/theme.dart' as CustomTheme;

class VocabDetailsUIPage extends StatefulWidget 
{
  final String title;
  vocabulary TargetWord;

  //Constructor
  VocabDetailsUIPage( vocabulary word, {Key key, this.title, }  ) : super( key: key){ this.TargetWord = word; }

  @override
  _VocabDetailsUIPage createState() => _VocabDetailsUIPage( this.TargetWord );
}



class _VocabDetailsUIPage extends State<VocabDetailsUIPage>
{
  vocabulary TargetWord; 


  //Constructor
  @override
  _VocabDetailsUIPage( vocabulary vocab ){  this.TargetWord = vocab; }

  @override
  void initState(){ super.initState(); }

  
  List<Widget> buildBackground(){
    return <Widget>
        [ 
          //BackgroundImage
          Container
          (
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.32,
            child: TargetWord.getImage(),
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
                      title: Text(TargetWord.getWord() ),
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                      elevation: 0, 
                    ),
                  ),

                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 80, 0, 0),
                    child: Text ( TargetWord.getWord(), style: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold, ),  ),
                  ),
                  
                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text( TargetWord.getWordForm(), style: TextStyle(color: Colors.blue, fontSize: 18, ),  ),
                  ),


                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Icon(Icons.audiotrack, color: CustomTheme.BLACK,),
                  ),


                  //HardCoded Example
                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new DefinitionBlock( header: "Meaning", body: TargetWord.getMeaning() ),                        
                  ),

                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new DefinitionBlock( header: "Example Sentence", body: TargetWord.getSampleSentence() ),                        
                  ), 
                  
                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new DefinitionBlock( header: "Synonyms", body: TargetWord.printSynonyms()),                        
                  ),

                  Container
                  (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new DefinitionBlock( header: "Synonyms", body: TargetWord.printAntonyms()),                        
                  ),

                  //HardCoded Example 
                
              ],
            ),



        ],),
      ),),

    );   
  }         
                         
}


