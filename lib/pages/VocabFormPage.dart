import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/pages/MainPageView.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/provider/addVocabFormController.dart';
import 'package:vocab_app_fyp55/services/fetchdata_WordsAPI.dart';
import 'package:vocab_app_fyp55/services/fetchimage_Bing.dart';
import 'package:vocab_app_fyp55/pages/VocabBanksPage.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as CustomTheme;



class VocabFormPage extends StatefulWidget
{
  final String title;
  final VocabBundle initVocab;
  
  //Constructor
  VocabFormPage( {Key key, String title = "Create a new word", VocabBundle vocab} ) 
  : title = title, 
  initVocab = vocab,
  super(key: key);

  @override
  _VocabFormPage createState() => _VocabFormPage();
}




class _VocabFormPage extends State <VocabFormPage> with TickerProviderStateMixin
{
  //Show image select
  bool showImageSelect = false;
  
  //A list of image available for selection
  List<String> imageSelectURLs = [];

  //image URL  
  String _imageURL = "";

  //image presented in the add vocab page, using the FLutter logo one by default until changes
  Widget _bgImage = new Image( image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover);

  //the key of form field which modify the word string itself
  final _wordFormFieldKey = new GlobalKey<FormFieldState>();

  //wordController for the word itself
  TextEditingController wordController = new TextEditingController();

  //Each FormController contains all the necessary forms 
  List<AddVocabFormController> formControllers = [ new AddVocabFormController()];

  //Each Form must have a related key
  List<GlobalKey<FormState>> formKeys = [ new GlobalKey<FormState>() ];


  @override
  void initState() {
    super.initState();
    fillVocabForm(widget.initVocab, doUpdateImage: true);
  }


  @override
  void dispose(){
    for ( var controller in formControllers )
      controller.dispose();
    super.dispose();
  }


  /// init all the form, if there is a vocab available
  /// return false if cannot be filled
  /// [vocab] - the vocabulary Bundle
  /// [doUpdateImage] - Optional parameter in updating the image
  Future<bool> fillVocabForm( VocabBundle vocab, {bool doUpdateImage = false }) async {
    try {
      if (vocab == null ){return false;}
      
      //Update Word
      this.wordController.text = vocab.word;

      //Update Image when needed
      if (doUpdateImage){
        this._imageURL = vocab.imageUrl;
        this._bgImage = vocab.getImage();
      }

      //Update definitions, examples 
      //TODO: pronunciation
      for ( int i = 0; i < vocab.definitionsBundle.length; i++ ){
        if ( i > 0 ){
          this.formKeys.add(new GlobalKey<FormState>());
          this.formControllers.add( new AddVocabFormController());
        }
        var definition = vocab.definitionsBundle[i];
        formControllers[i].wordPartOfSpeechController.text = definition.pos ?? "unknown";
        formControllers[i].wordDefinitionController.text = definition.defineText ?? "";
        formControllers[i].wordSampleSentenceController.text = (definition.examplesBundle.length != 0 ) ? definition.examplesBundle[0].sentence : "";
      }
    }
    catch( exception ){ debugPrint("Fatal Error in auto-filling the vocab form. Process Terminated\n" + exception.toString() ); return false; }
    setState(() { });
    return true;
  }


  Future<List<String>> openImageSelection() async {
    try {
      this.imageSelectURLs = await FetchImage.requestImgURLs(wordController.text);
      this.showImageSelect = true;
      return this.imageSelectURLs;
    }
    catch (Exception){ this.imageSelectURLs = []; return []; }
  }



  //changes image of the vocab
  bool selectImage(String url){
    try{
      _imageURL = url;
      _bgImage = Image.network(url, fit: BoxFit.cover, );
      setState(() { });
      return true;
    } catch (Exception){ return false; }
  }



  //this function automatically fills the form based on API calls
  Future<bool> autoFillForms() async {
    try{
      VocabBundle vocab = await FetchDataWordsAPI.requestFromAPI(wordController.value.text);
      return fillVocabForm(vocab);
    } catch (Exception){debugPrint("Failed to auto-fill form"); return false;}
  }
  


  //This function allows addition of new vocabs description
  void addNewForm(){
    formKeys.add(new GlobalKey<FormState>());
    formControllers.add( new AddVocabFormController());
    setState(() { });
  }


  /// Function called after submitting the form
  /// update new vocab, in such case update can be: either create new vocab or update existing vocab
  /// TODO: More to Add?
  Future<bool> updateNewVocab() async {
    try {
      //Insert Vocab
      String word = wordController.text;
      String imageUrl = _imageURL;
      int vid = await DatabaseProvider.instance.insertVocab( new Vocab( word: word, imageUrl: imageUrl,) );

      //Insert FlashCard
      await DatabaseProvider.instance.insertFlashcard( new Flashcard(vid: vid));

      //Insert Definitions
      for (int i = 0; i < formControllers.length; i++ ){
        String pos = formControllers[i].wordPartOfSpeechController.text;
        String defineText =  formControllers[i].wordDefinitionController.text;
        int did = await DatabaseProvider.instance.insertDefinition( new Definition( vid: vid, pos: pos, defineText: defineText, ) );


        //Insert Pronunciation
        await DatabaseProvider.instance.insertPronunciation( new Pronunciation( did: did));

        //Insert Example     
        await DatabaseProvider.instance.insertExample( new Example(did: did, sentence: formControllers[i].wordSampleSentenceController.text ) );       
      }
          
      print("Successfully Update the vocab");
      return true;
    } catch (e){ print( "Fatal Error in submitting:\n" + e.toString()); return false; }
  }

  
 
  //Function that return Widget of the background
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
                borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ];      
  }



  //Function that returns the widget input field
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


  //Function that returns the form built, containing the input fields
  Widget buildForm( AddVocabFormController formController, GlobalKey<FormState> key, {int index = -1}  ){
    return
    Form(
      key: key,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        initiallyExpanded: true,
        trailing: IconTheme( data: IconThemeData(color: Colors.black,), child: Icon(Icons.menu),  ),
        title: Text( "DEFINITION " + ((index == -1) ? "" : (index+1).toString())  , style: TextStyle(color: Colors.blue, fontSize: 20, ), ),
        children: <Widget>[
            buildInputField("Word of Speech", formController.wordPartOfSpeechController),
            buildInputField("Definition", formController.wordDefinitionController),
            buildInputField("Sample Sentence", formController.wordSampleSentenceController),
            buildInputField("Synonyms", formController.wordSynonymsController),
            buildInputField("Antonyms", formController.wordAntonymsController),
        ],
      ),
    );
  }




  //the main user interface
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
                  title: Text( widget.title, 
                  style: TextStyle(color: Color.fromRGBO(255,255,255,0.8)), ),
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                  elevation: 0, 
                ),
              ),

              //Editable Word Title
              Container 
              (
                padding: EdgeInsets.fromLTRB(0, 60, 0, 10),
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextFormField
                (
                  key: this._wordFormFieldKey,
                  controller: this.wordController,
                  style: TextStyle(color: Colors.blue, fontSize: 22),
                  decoration: InputDecoration(
                    fillColor: Colors.blue,
                    hintText: "Enter the word here",
                    hintStyle: TextStyle(fontSize: 22.0, color: Colors.blue),
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Please Enter the Word here";
                    return null;
                  }
                ),
              ),

              //A Row of buttons
              Row (children: <Widget>[
                //AutoFill button
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(18.0), ),
                    color: Colors.red,
                    child: Text("Fill by hand? Try it automatically!"),   
                    onPressed:() async { 
                      if ( this._wordFormFieldKey.currentState.validate() )                           
                        await autoFillForms();
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
                      if ( this._wordFormFieldKey.currentState.validate() ){         
                        await openImageSelection();
                        setState(() { });
                      }
                    },
                  ),
                ),
              ]),


              //Image selection gallery, only visible when selected
              (! showImageSelect ) ? Container() : 
              FutureBuilder<List<String>>(
                future: openImageSelection(),
                builder: (context, AsyncSnapshot<List<String>> snapshot){
                  if ( snapshot.hasData){
                    return Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.25,
                      color: CustomTheme.BLACK,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, position){
                          return 
                          GestureDetector (
                            onTap: (){ 
                              selectImage(imageSelectURLs[position]);
                              showImageSelect = false;
                              setState(() { });
                            },
                            child: Image.network(imageSelectURLs[position], fit: BoxFit.cover, ),
                          );
                        },
                      ),
                    );
                  } else return Container(child: Text("Loading, please wait"),);
                }
              ),


              //Forms
              Column(
                children: formControllers.asMap().map((i, element) => MapEntry(i, 
                  buildForm(formControllers[i], formKeys[i], index: i),
                )).values.toList(),
              ),

             

              //Add more Definition Button
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text("Add a new definition"),   
                  onPressed:(){ 
                    //Do Something
                    addNewForm();
                  } 
                ),
              ),


              //Submit button
              Container (
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: RaisedButton(
                child: Text("Create New Word"),
                onPressed: () async {
                  if (_wordFormFieldKey.currentState.validate()) {
                    await updateNewVocab();
                    Navigator.of(context).pop();
                    setState(() { });
                  }
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