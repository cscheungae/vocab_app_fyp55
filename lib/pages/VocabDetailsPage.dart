
import 'package:flutter/material.dart';
import '../States/vocabularyState.dart';
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


  //Widget Building
  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (        
      backgroundColor: Colors.white, 
      body: Stack
      (
        children: <Widget>
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

          //Information Body
          Column
          (    
            children: <Widget>
            [
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

              Padding
              (
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:Container
                (
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  decoration: new BoxDecoration
                  ( 
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                  ),
                  alignment: Alignment.topLeft,

                  child: Column
                  (
                    children: <Widget>
                    [
                      Container
                      (
                        alignment: Alignment.topLeft,
                        child: Text ( TargetWord.getWord(), style: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold, ),  ),
                      ),
                      
                      Container
                      (
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text( "Some Form of Speech", style: TextStyle(color: Colors.blue, fontSize: 18, ),  ),
                      ),

                      Container
                      (
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Icon(Icons.audiotrack, color: CustomTheme.BLACK,),
                      ),

                      Container
                      (
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text( "Hello Everyone this is a lovely vocab card description about " + TargetWord.getWord() + ", you can learn more about it in here", 
                        style: TextStyle(
                          color: CustomTheme.BLACK, 
                          fontSize: 18, 
                          ),  
                        ),
                      ),
                                          
                    ],
                  )
                  
                ),
              ),

            ],
          ),

        ],
      ),

    );   
  }         
                         
}