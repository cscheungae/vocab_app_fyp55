import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/services/fetchdata_WordsAPI.dart';
import 'package:vocab_app_fyp55/services/fetchimage_Bing.dart';
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
  String _imageURL = "";
  var _bgImage = Image( image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover);

  final _wordKey = GlobalKey<FormState>();
  final _wordFKey = GlobalKey<FormFieldState>();

  var wordFController = TextEditingController();
  var wordOfSpeechController = TextEditingController();
  var wordMeaningController = TextEditingController();
  var wordSampleSentenceController = TextEditingController();

  var wordSynonymsController = TextEditingController();
  var wordAntonymsController = TextEditingController();

  
  @override
  bool get wantKeepAlive => true;


  @override
  void dispose(){
    wordFController.dispose();
    wordOfSpeechController.dispose();
    wordMeaningController.dispose();
    wordSampleSentenceController.dispose();

    wordSynonymsController.dispose();
    wordAntonymsController.dispose();

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
            child: _bgImage,
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




  Widget buildInputField( String header, TextEditingController controller ){
    return 
    Container (
      width: MediaQuery.of(context).size.width * 0.95, 
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),    
        child: Card(
          color: Colors.white,
          elevation: 2,
          child: (
            Column(
              children: <Widget>[
                Container (
                  alignment: Alignment.topLeft,  
                  child: Text( header + ": ", style: TextStyle(color: Colors.redAccent, fontSize: 20),  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9, 
                  child: TextFormField(
                    controller: controller,
                    style: TextStyle(color: Colors.black, ),
                    validator: (value) {
                      if (value.isEmpty)
                        return header + " not filled, please fill in here";
                      return null;
                    }
                  ),
                ),

              ],
            )
          ),
        ),
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
                child: Column(children: <Widget>[

                    Container 
                    (
                      padding: EdgeInsets.fromLTRB(0, 60, 0, 10),
                      width: MediaQuery.of(context).size.width * 0.90,
                      
                      child: TextFormField
                      (
                        key: _wordFKey,
                        controller: wordFController,
                        style: TextStyle(color: Colors.blue, fontSize: 22),
                        decoration: InputDecoration(
                          fillColor: Colors.blue,
                          hintText: "Enter the word here",
                          hintStyle: TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Please Enter the Word here";
                          return null;
                        }
                      ),
                    ),


                    Row (children: <Widget>[

                      //AutoFill button
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(18.0), ),
                          color: Colors.red,
                          child: Text("Fill by hand? Try it automatically!"),
                          onPressed: () async{        

                            if ( _wordFKey.currentState.validate() ){
                              vocabulary vocab = await FetchDataWordsAPI.requestFromAPI(wordFController.value.text);
                              
                              if ( vocab != null ){
                                print(vocab.getMeaning());
                                wordOfSpeechController.text = vocab.getWordForm();
                                wordMeaningController.text = vocab.getMeaning();
                                wordSampleSentenceController.text = vocab.getSampleSentence();
                                
                                wordSynonymsController.text = vocab.printSynonyms();
                                wordSynonymsController.text = vocab.printAntonyms();

                              }
                            }
                          }
                        ),
                      ),

                      //AutoFill picture button
                      Container (
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                          color: Colors.blue,
                          child: Text("I"),
                          onPressed: () async{
                            if ( _wordFKey.currentState.validate() ){                         
                              String url = await FetchImage.requestImgURL(wordFController.text);
                              _imageURL = url;
                              _bgImage = Image.network(url, fit: BoxFit.cover, );
                              setState(() {  });
                            }
                          },
                        ),
                      )

                    ]),

                    buildInputField("Word of Speech", wordOfSpeechController),
                    buildInputField("Meaning", wordMeaningController),
                    buildInputField("Sample Sentence", wordSampleSentenceController),
                    buildInputField("Synonyms", wordSynonymsController),
                    buildInputField("Antonyms", wordAntonymsController),


                    //Submit button
                    Container (
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: RaisedButton(
                      child: Text("Create New Word"),
                      onPressed: () async {
                         if (_wordFKey.currentState.validate()) {
                            
                            vocabulary newVocab = new vocabulary(
                              word: wordFController.text,
                              wordForm: wordOfSpeechController.text,
                              meaning: wordMeaningController.text,
                              sampleSentence: wordSampleSentenceController.text,
                              imageURL: _imageURL, 
                            ); 

                            await vocabularyBankState.instance.createNewVocab(newVocab);
                            Navigator.of(context).pop();
                         }
                      },
                    ),
                  ),

                ],),
              ),

            ],
          ),    
        ],
            
        ),
      ),),

    );
  }
}