import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vocab_app_fyp55/pages/MainPageView.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/components/DefinitionBlock.dart';
import 'package:vocab_app_fyp55/pages/VocabFormPage.dart';


class VocabDetailsUIPage extends StatefulWidget 
{
  final String title;
  final VocabBundle targetWord;

  //Constructor
  VocabDetailsUIPage( VocabBundle word, {Key key, String title = "vocabulary", }):
  this.title = title,
  this.targetWord = word, 
  super( key: key);

  @override
  _VocabDetailsUIPage createState() => _VocabDetailsUIPage( this.targetWord );
}



class _VocabDetailsUIPage extends State<VocabDetailsUIPage> with SingleTickerProviderStateMixin
{
  VocabBundle targetWord; 
  @override
  _VocabDetailsUIPage( VocabBundle vocab ){  this.targetWord = vocab; }

  /// Tab related variable
  TabController _defTabController;
  int defIndex = 0;

  /// Audio button color
  static final Color idleAudioColor = Colors.black;
  static final Color runAudioColor = Colors.lightBlue;
  Color audioColor = idleAudioColor;



  @override
  void initState(){ 
    super.initState(); 

    //if nothing, it's still be 1 because we at least want to show the UI
    int deflength = ( targetWord.definitionsBundle != null ) ? targetWord.definitionsBundle.length : 1;
    _defTabController =  TabController(length: deflength, vsync: this );
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
          title: new Text("Delete the vocabulary " + targetWord.word ),
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
                try {
                  await DatabaseProvider.instance.deleteVocab(targetWord.vid);
                  Navigator.of(context).pop("delete");
                  Navigator.of(context).pop("delete");
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPageView.instance ) );
                }
                catch (exception){ debugPrint("Failure in deletion\n" + exception); }
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
            child: targetWord.getImage(),
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
  Widget _buildDefinition( DefinitionBundle vd ){

    if (vd==null){
      vd = new DefinitionBundle();
      vd.defineText = "";
      vd.pos = "";
      vd.examplesBundle = [];
      vd.pronunciationsBundle = [];
    }

    String ipa = (vd.pronunciationsBundle != null && vd.pronunciationsBundle.isNotEmpty)
    ? "/" + vd.pronunciationsBundle[0].ipa + "/" : "";
      


    return Column(children: <Widget>[
        
        //Part Of Speech && ipa
        Row(children: <Widget>[
          Container
          (
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text( vd.pos , style: TextStyle(color: Colors.blue, fontSize: 18, ),  ),
          ),
          Container
          (
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text( ipa , style: TextStyle(color: Colors.blue, fontSize: 18, ),  ),
          ),
        ],),


       Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Meaning", body: vd.defineText ),                        
        ),   
        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Example 1", body: (vd.examplesBundle.length > 0 ) ? vd.examplesBundle[0].sentence : "" , initiallyExpanded: false, ),                        
        ),  
        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Example 2", body: (vd.examplesBundle.length > 1 ) ? vd.examplesBundle[1].sentence : "" , initiallyExpanded: false,),                        
        ),
        Container
        (
          alignment: Alignment.topLeft,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new DefinitionBlock( header: "Example 3", body: (vd.examplesBundle.length > 2 ) ? vd.examplesBundle[2].sentence : "" , initiallyExpanded: false,),                        
        ),
    ],);
  }
  



  //Widget Building
  @override
  Widget build( BuildContext context )
  {
    PronunciationBundle pb;
    if (targetWord.definitionsBundle != null ){
      for ( var def in targetWord.definitionsBundle ){
        if (def.pronunciationsBundle != null && def.pronunciationsBundle.length != 0 ){
          pb= def.pronunciationsBundle[0];
        }
      }
    }


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
                      title: Text(targetWord.word ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: (){
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new VocabFormPage(
                               title: "Edit " + targetWord.word , vocab: targetWord,
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
                    padding: EdgeInsets.fromLTRB(15, 80, 0, 5),
                    child: Text ( targetWord.word, style: TextStyle(color: Colors.blue, fontSize: 28, fontWeight: FontWeight.bold, ),  ),
                  ),

                  
                  (pb == null  ) ? Container() : 
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
                    child: GestureDetector(
                      child: Icon( Icons.speaker, color: this.audioColor, size: 30, ), 
                      onTap: () async {

                        if (pb.audioUrl == "")
                          return;

                        try {
                          setState(() {  this.audioColor = runAudioColor; });
                          AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
                          await audioPlayer.play(pb.audioUrl, isLocal: false );
                          setState(() {  this.audioColor = idleAudioColor; });
                        } catch(exception){ Toast.show("Oops, seems like audio having some trouble!", context); }
                      },
                    ),
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
                      tabs: ( targetWord.definitionsBundle == null || targetWord.definitionsBundle.isEmpty )  ? 
                      <Widget>[
                        Tab(
                          child: Text("DEF", style: TextStyle(fontSize: 14),),
                        )
                      ] 
                      :  targetWord.definitionsBundle.map((context){
                        //* if too many definitions
                        if (targetWord.definitionsBundle.length > 5 ){
                          return Tab (
                            child: Text("*"),
                          );
                        }
                        else return Tab(
                          child: Text("DEF", style: TextStyle(fontSize: 14),),
                        );
                      }).toList(),
                    ),
                  ),

                  //Definitions
                  ( targetWord.definitionsBundle == null || targetWord.definitionsBundle.isEmpty )  ? _buildDefinition(null) : targetWord.definitionsBundle.map((context){
                    return _buildDefinition(context);
                  }).toList()[defIndex],
                  
              ],
            ),

        ],),
      ),),

    );   
  }         
                         
}


