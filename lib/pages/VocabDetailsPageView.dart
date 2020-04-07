
import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/components/ErrorAlert.dart';
import 'package:vocab_app_fyp55/components/LoadingIndicator.dart';
import 'package:vocab_app_fyp55/model/Bundle/AllBundles.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import '../pages/VocabDetailsPage.dart';


/// This Page View allows swiping between Vocabularies
/// It also handles the important transition from [Vocab] to [VocabBundle]
class VocabDetailsPageView extends StatefulWidget {

  final List<Vocab> _vocabList;
  final int _startPage;

  List<Vocab> get vocablist => _vocabList; 

  //Constructor
  VocabDetailsPageView( List<Vocab> vocablist, { int startPage = 0,  Key key} ): 
  this._vocabList = vocablist,
  this._startPage = startPage,
  super(key: key);

  @override
  _VocabDetailsPageView createState() => _VocabDetailsPageView();

}



class _VocabDetailsPageView extends State<VocabDetailsPageView>
{
  PageController pController;

  List<VocabBundle> vocabBundlesList;

  @override
  void initState() {
    super.initState();
    pController = new PageController(initialPage: widget._startPage, );
  }

  @override
  void dispose() {
    pController.dispose();
    super.dispose();
  }

  Future<List<VocabBundle>> initVocabBundleList() async {
    this.vocabBundlesList = [];
    for ( int i = 0; i < widget._vocabList.length; i++ ){
      VocabBundle vb = await DatabaseProvider.instance.readVocabBundle( widget._vocabList[i].vid );
      this.vocabBundlesList.add(vb);
    }
    return this.vocabBundlesList;
  }



  @override
  Widget build( BuildContext context ){
    return 
    FutureBuilder<List<VocabBundle>>(
      future: initVocabBundleList(),
      builder: ( context, AsyncSnapshot<List<VocabBundle>> snapshot ){
        if ( snapshot.hasData ){
          return PageView.builder(
            itemBuilder: ( context, position ){
              return VocabDetailsUIPage( this.vocabBundlesList[position] , title: this.vocabBundlesList[position].word );
            },
            controller: pController,
            itemCount: widget.vocablist.length,
            scrollDirection: Axis.horizontal,
          );
        }
        //Error
        else if ( snapshot.hasError ) return new ErrorAlert("vocabularies");
        else return new LoadingIndicator();
      },
    );
  }


}