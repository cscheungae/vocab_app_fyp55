import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:toast/toast.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/provider/addVocabFormController.dart';
import 'package:vocab_app_fyp55/services/fetchdata_OxfordAPI.dart';
import 'package:vocab_app_fyp55/services/fetchimage_Bing.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as CustomTheme;

class VocabFormPage extends StatefulWidget {
  final String title;
  final VocabBundle initVocab;

  //Constructor
  VocabFormPage(
      {Key key, String title = "Create a new word", VocabBundle vocab})
      : title = title,
        initVocab = vocab,
        super(key: key);

  @override
  _VocabFormPage createState() => _VocabFormPage();
}

class _VocabFormPage extends State<VocabFormPage>
    with TickerProviderStateMixin {
  //Show image select
  bool showImageSelect = false;

  //A list of image available for selection
  List<String> imageSelectURLs = [];

  //image URL
  String _imageURL = "";

  //image presented in the add vocab page, using the FLutter logo one by default until changes
  Widget _bgImage = new Image(
      image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover);

  //the key of form field which modify the word string itself
  final _wordFormFieldKey = new GlobalKey<FormFieldState>();

  //wordController for the word itself
  TextEditingController wordController = new TextEditingController();

  //Each FormController contains all the necessary forms
  List<AddVocabFormController> formControllers = [new AddVocabFormController()];

  //Each Form must have a related key
  List<GlobalKey<FormState>> formKeys = [new GlobalKey<FormState>()];

  //audio
  PronunciationBundle pb; 

  @override
  void initState() {
    super.initState();
    fillVocabForm(widget.initVocab, doUpdateImage: true);
  }

  @override
  void dispose() {
    for (var controller in formControllers) controller.dispose();
    super.dispose();
  }

  /// init all the form, if there is a vocab available
  /// return false if cannot be filled
  /// [vocab] - the vocabulary Bundle
  /// [doUpdateImage] - Optional parameter in updating the image
  bool fillVocabForm(VocabBundle vocab, {bool doUpdateImage = false}) {
    try 
    {
      if (vocab == null) 
        return false;

      //Audio
      if (vocab.definitionsBundle != null  ){
        for ( var def in vocab.definitionsBundle ){
          if (def.pronunciationsBundle != null && def.pronunciationsBundle.isNotEmpty )
            this.pb = def.pronunciationsBundle[0];
        }
      }  

      //Update Word
      this.wordController.text = vocab.word;

      //Update Image when needed
      if (doUpdateImage) {
        this._imageURL = vocab.imageUrl;
        this._bgImage = vocab.getImage();
      }

      //Update definitions, examples
      //TODO: pronunciation
      for (int i = 0; i < vocab.definitionsBundle.length; i++) {
        if (i > 0) {
          this.formKeys.add(new GlobalKey<FormState>());
          this.formControllers.add(new AddVocabFormController());
        }
        var definition = vocab.definitionsBundle[i];
        formControllers[i].wordPartOfSpeechController.text =
            definition.pos ?? "unknown";
        formControllers[i].wordDefinitionController.text =
            definition.defineText ?? "";
        formControllers[i].wordExampleController1.text =
            (definition.examplesBundle.length > 0)
                ? definition.examplesBundle[0].sentence
                : "";
        formControllers[i].wordExampleController2.text =
            (definition.examplesBundle.length > 1)
                ? definition.examplesBundle[1].sentence
                : "";
        formControllers[i].wordExampleController3.text =
            (definition.examplesBundle.length > 2)
                ? definition.examplesBundle[2].sentence
                : "";
      }
    } catch (exception) {
      debugPrint(
          "Fatal Error in auto-filling the vocab form. Process Terminated\n" +
              exception.toString());
      return false;
    }
    setState(() {});
    return true;
  }



  Future<List<String>> openImageSelection() async {
    try {
      this.imageSelectURLs =
          await FetchImage.requestImgURLs(wordController.text);
      this.showImageSelect = true;
      return this.imageSelectURLs;
    } catch (Exception) {
      this.imageSelectURLs = [];
      return [];
    }
  }

  //changes image of the vocab
  bool selectImage(String url) {
    try {
      _imageURL = url;
      _bgImage = Image.network(
        url,
        fit: BoxFit.cover,
      );
      setState(() {});
      return true;
    } catch (Exception) {
      return false;
    }
  }

  //this function automatically fills the form based on API calls
  Future<bool> autoFillForms() async {
    try {
      Toast.show("processing", context);
      VocabBundle vocab = await FetchDataOxfordAPI.requestFromAPI(wordController.value.text);
      Toast.show("success!", context);
      return fillVocabForm(vocab);
    } catch (Exception) {
      debugPrint("Failed to auto-fill form");
      return false;
    }
  }

  //This function allows addition of new vocabs description
  void addNewForm() {
    formKeys.add(new GlobalKey<FormState>());
    formControllers.add(new AddVocabFormController());
    setState(() {});
  }

  /// Function called after submitting the form
  /// update new vocab, in such case update can be: either create new vocab or update existing vocab
  Future<bool> updateNewVocab() async {
    try {
      //Insert Vocab
      String word = wordController.text;
      String imageUrl = _imageURL;
      Status status = Status.learning;

      int vid;
      Vocab existVocab = await DatabaseProvider.instance.getVocab(word);

      //Case 1, completely new word
      if ( existVocab == null ){
        print("New word");
        vid = await DatabaseProvider.instance.insertVocab( new Vocab( word: word, imageUrl: imageUrl, status: status) );
      }
      //Case 2, tracked word, which also updated its state
      else if ( existVocab.status == Status.tracked ) {
        print("Tracked Word to Learning Card");
        existVocab.imageUrl = _imageURL;
        existVocab.status = status;
        vid = existVocab.vid;
        await DatabaseProvider.instance.updateVocab(existVocab);
      }
      //Case 3, update learning/mature word, delete old definitions required
      else {
        print("Learning/Mature Word");

        //Delete All existing definitions
        var defs = ( await DatabaseProvider.instance.readDefinition(existVocab.vid)) ?? [];
        for ( int i = 0; i < defs.length; i++ )  
          await DatabaseProvider.instance.deleteDefinition( defs[i].did );

        existVocab.imageUrl = _imageURL;
        vid = existVocab.vid;
        await DatabaseProvider.instance.updateVocab(existVocab);
      }
      

      //Insert New FlashCard, if needed
      if ( await DatabaseProvider.instance.readFlashcard(vid) == null  )
        await DatabaseProvider.instance.insertFlashcard(new Flashcard(vid: vid));

      //Insert Definitions
      for (int i = 0; i < formControllers.length; i++) {

        //Ignore empty form
        if (formControllers[i].wordDefinitionController.text == "" &&
            formControllers[i].wordPartOfSpeechController.text == "" &&
            formControllers[i].wordExampleController1.text == "" &&
            formControllers[i].wordExampleController2.text == "" &&
            formControllers[i].wordExampleController2.text == ""
        )
          continue;


        String pos = formControllers[i].wordPartOfSpeechController.text;
        String defineText =  formControllers[i].wordDefinitionController.text;
        int did = await DatabaseProvider.instance.insertDefinition( new Definition( vid: vid, pos: pos, defineText: defineText, ) );

        //Insert Pronunciation
        if (pb != null )
          await DatabaseProvider.instance.insertPronunciation(new Pronunciation(did: did, audioUrl: pb.audioUrl, ipa: pb.ipa ));

        //Insert Example
        if (formControllers[i].wordExampleController1.text != ""  )     
          await DatabaseProvider.instance.insertExample( new Example(did: did, sentence: formControllers[i].wordExampleController1.text ) );
        if (formControllers[i].wordExampleController2.text != ""  )   
          await DatabaseProvider.instance.insertExample( new Example(did: did, sentence: formControllers[i].wordExampleController2.text ) );       
        if (formControllers[i].wordExampleController3.text != ""  )   
          await DatabaseProvider.instance.insertExample( new Example(did: did, sentence: formControllers[i].wordExampleController3.text ) );              
      } 
              
      Toast.show("Success in submitting", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.white70);
      return true;
    } catch (e) {
      print("Fatal Error in submitting:\n" + e.toString());
      return false;
    }
  }

  //Function that return Widget of the background
  List<Widget> buildBackground() {
    return <Widget>[
      //BackgroundImage
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.32,
        child: _bgImage,
      ),

      //Image Filter
      Container(
        height: MediaQuery.of(context).size.height * 0.32,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.white,
                ],
                stops: [
                  0.0,
                  1.0,
                ])),
      ),

      Padding(
        padding: EdgeInsets.fromLTRB(5, 110, 5, 0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.98,
          height: MediaQuery.of(context).size.height * 0.98,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.7),
            borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
          ),
          alignment: Alignment.topLeft,
        ),
      ),
    ];
  }

  //Function that returns the widget input field
  Widget buildInputField(String header, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: (Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                header + ": ",
                style: TextStyle(color: Colors.redAccent, fontSize: 20),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return header + " not filled, please fill in here";
                    return null;
                  }),
            ),
          ],
        )),
      ),
    );
  }

  //Function that returns the form built, containing the input fields
  Widget buildForm(
      AddVocabFormController formController, GlobalKey<FormState> key,
      {int index = -1}) {
    return Form(
      key: key,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        initiallyExpanded: true,
        trailing: IconTheme(
          data: IconThemeData(
            color: Colors.black,
          ),
          child: Icon(Icons.menu),
        ),
        title: Text(
          "DEFINITION " + ((index == -1) ? "" : (index + 1).toString()),
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        children: <Widget>[
          //Delete Button
          (index != 0 ) ? Padding (
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                child: Icon(Icons.delete, color: Colors.black,),
                onTap: (){
                  setState(() {
                    this.formControllers[index].dispose();
                    this.formControllers.removeAt(index);
                    this.formKeys.removeAt(index);
                  });
                }
              ),
            ) 
          ): Container(),
          buildInputField(
              "Word of Speech", formController.wordPartOfSpeechController),
          buildInputField(
              "Definition", formController.wordDefinitionController),
          buildInputField(
              "Example", formController.wordExampleController1 ),
          buildInputField(
              "Example 2", formController.wordExampleController2 ),
          buildInputField(
              "Example 3", formController.wordExampleController3 ),
        ],
      ),
    );
  }

  //the main user interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: List.from(buildBackground())
            ..addAll(
              <Widget>[
                Column(
                  children: <Widget>[
                    //Appbar
                    Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: AppBar(
                        title: Text(
                          widget.title,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.8)),
                        ),
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                        elevation: 0,
                      ),
                    ),

                    //Editable Word Title
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 60, 0, 10),
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: TextFormField(
                          key: this._wordFormFieldKey,
                          controller: this.wordController,
                          style: TextStyle(color: Colors.blue, fontSize: 22),
                          decoration: InputDecoration(
                            fillColor: Colors.blue,
                            hintText: "Enter the word here",
                            hintStyle:
                                TextStyle(fontSize: 22.0, color: Colors.blue),
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please Enter the Word here";
                            return null;
                          }),
                    ),

                    //A Row of buttons
                    Row(children: <Widget>[
                      //AutoFill button
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                            color: Colors.red,
                            child: Text("Fill by hand? Try it automatically!"),
                            onPressed: () async {
                              if (this
                                  ._wordFormFieldKey
                                  .currentState
                                  .validate()) await autoFillForms();
                            }),
                      ),

                      //AutoFill picture button
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                          color: Colors.blue,
                          child: Text("I"),
                          onPressed: () async {
                            if (this
                                ._wordFormFieldKey
                                .currentState
                                .validate()) {
                              await openImageSelection();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ]),

                    //Image selection gallery, only visible when selected
                    (!showImageSelect)
                        ? Container()
                        : FutureBuilder<List<String>>(
                            future: openImageSelection(),
                            builder: (context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  color: CustomTheme.BLACK,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 8,
                                    itemBuilder: (context, position) {
                                      return GestureDetector(
                                        onTap: () {
                                          selectImage(
                                              imageSelectURLs[position]);
                                          showImageSelect = false;
                                          setState(() {});
                                        }, 
                                        child: Image(
                                          image: NetworkImageWithRetry(imageSelectURLs[position]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else
                                return Container(
                                  child: Text("Loading, please wait"),
                                );
                            }),

                    //Forms
                    Column(
                      children: formControllers
                          .asMap()
                          .map((i, element) => MapEntry(
                                i,
                                buildForm(formControllers[i], formKeys[i],
                                    index: i),
                              ))
                          .values
                          .toList(),
                    ),

                    //Add more Definition Button
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Text("Add a new definition"),
                          onPressed: () {
                            //Do Something
                            addNewForm();
                          }),
                    ),

                    //Submit button
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: RaisedButton(
                        child: Text( (widget.title.contains("Edit")) ? "Edit the flashcard!" : "Make New flashcard!"),
                        onPressed: () async {
                          if (_wordFormFieldKey.currentState.validate()) {
                            await updateNewVocab();
                            Navigator.pop(context, true);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}
