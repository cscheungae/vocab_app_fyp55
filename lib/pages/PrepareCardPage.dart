
import 'package:toast/toast.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/definition.dart';
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';

import '../res/theme.dart' as CustomTheme;
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';

import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/pages/VocabFormPage.dart';
import 'package:vocab_app_fyp55/services/fetchdata_OxfordAPI.dart';
import 'package:vocab_app_fyp55/services/fetchimage_Bing.dart';


class PrepareCardPage extends StatefulWidget {
  
  //Constructor
  PrepareCardPage({Key key}) : super(key: key);

  @override
  _PrepareCardPage createState() => _PrepareCardPage();
}



class _PrepareCardPage extends State<PrepareCardPage> with SingleTickerProviderStateMixin {

  //vocabs through UI
  List<Vocab> _readyVocabList;

  ///controller and animation
  AnimationController animeController;
  Animation fadeAnimation;

 


  @override
  void initState() {
    super.initState();
    animeController = AnimationController( duration: const Duration(milliseconds: 700), vsync: this);
    fadeAnimation = Tween( begin: 0.0, end: 1.0,).animate(animeController);
  }


  @override
  void dispose() {
    animeController.dispose();
    super.dispose();
  }


  Future<void> _refresh() async {
    await initReadyWordsList(forceUpdate: true);
    print("it's forced");
    setState(() { });
  }
  

  /// initialize the Ready Vocab List (i.e. vocab that exceeds the threshold )
  /// Call the database, and check if the word exceed threshold (Ready) or not
  Future<List<Vocab>> initReadyWordsList({bool forceUpdate = false }) async
  {
    if (_readyVocabList == null || forceUpdate ){
      _readyVocabList = await DatabaseProvider.instance.getReadyVocab() ?? [];
      print("Length of ready vocab is: " + _readyVocabList.length.toString() );
    }
    return _readyVocabList;
  }


  //One click prepare
  Future<void> oneClickPrepare() async{
    try {
      for ( Vocab vocab in _readyVocabList ){
        VocabBundle vb = await FetchDataOxfordAPI.requestFromAPI(vocab.word);
        vocab.imageUrl = await FetchImage.requestImgURL(vocab.word);
        vocab.status = Status.learning;
        
        await DatabaseProvider.instance.updateVocab(vocab);
        await DatabaseProvider.instance.insertFlashcard( new Flashcard(vid: vocab.vid));
        for ( int i = 0; i < vb.definitionsBundle.length; i++){
          var dB = vb.definitionsBundle[i];
          int did = await DatabaseProvider.instance.insertDefinition(new Definition(vid: vocab.vid, pos: dB.pos, defineText: dB.defineText ));
          await DatabaseProvider.instance.insertPronunciation( new Pronunciation( did: did));        
          for ( int j = 0; j < dB.examplesBundle.length  ; j++ ){
            if (j==3) break;
            await DatabaseProvider.instance.insertExample( new Example(did: did, sentence: dB.examplesBundle[j].sentence  ));
          }
        }
        print(vb.word + " done");
      }
    } catch (exception){print("Preparation Failure:\n" + exception.toString() ); return; }
    setState(() { });
  }


  //prepare
  Future<void> prepareTracedWord(Item item) async {
    VocabBundle vb = await DatabaseProvider.instance.readVocabBundle(  _readyVocabList[item.index].vid  );
    Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabFormPage( title: "Prepare Traced Word - " + item.title,   vocab: vb, ) ) )
    .then((value) async {
      await this._refresh();
    });
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(        
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: RichText(
                maxLines: 3,
                text: TextSpan (
                  children: [
                    TextSpan(
                      text: "Ready word(s) for preparing flashcards:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ]
                ),
              ),
            ),
          ),

          //Ready Word
          FutureBuilder<List<Vocab>>(
            future: initReadyWordsList(),
            builder: ( context, AsyncSnapshot<List<Vocab>> snapshot ){
              if ( snapshot.hasData )
              {
                //No Ready Word
                if ( _readyVocabList.length == 0 ){
                  return Container(
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image(image: AssetImage("assets/empty.png"), fit: BoxFit.contain, ),
                      ),
                      Text("Currently, there is no word ready for perparing flashcard"),
                    ],),
                  );
                }
                else return 
                Container(
                  child: Tags(
                    itemCount: _readyVocabList.length,
                    columns: 5,
                    itemBuilder: (position){
                      return ItemTags(
                        index: position,
                        title: _readyVocabList[position].word ?? "",
                        textStyle: TextStyle(fontSize: 18),
                        onPressed: (item) async {
                          await prepareTracedWord(item);
                        },
                      );
                    },
                  )
                );
              } else if ( snapshot.hasError ){
                return Container(child: Text("Problem in loading the words", style: TextStyle(color: Colors.red),),);
              }
              else return Container();
            }
          ),

          //Buttons
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                        color: CustomTheme.TOMATO_RED,
                        child: Text("Return to Home"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        }
                      ),
                    ),
                    Container (
                      padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                        color: CustomTheme.LIGHT_GREEN,
                        child: Text("One-Click Prepare"),
                        onPressed: () async { 
                          Toast.show("Processing...", context);
                          await oneClickPrepare();
                          Toast.show("Success!", context);
                          Navigator.of(context).pop();
                          setState(() { });
                        },
                      ),
                    )
              ],),
            ),
          ),
        ],
      ),
    );
  }





}