
import 'package:flutter/material.dart';
import '../model/vocabulary.dart';
import '../pages/VocabDetailsPage.dart';



class VocabDetailsPageView extends StatefulWidget {

  List<vocabulary> _vocablist;
  List<vocabulary> get vocablist => _vocablist; 
  int _startPage;

  //Constructor
  VocabDetailsPageView( List<vocabulary> vocablist, { int startPage = 0,  Key key} ): super(key: key){
     this._vocablist = vocablist; 
     this._startPage = startPage;
  }

  @override
  _VocabDetailsPageView createState() => _VocabDetailsPageView();

}



class _VocabDetailsPageView extends State<VocabDetailsPageView>
{
  PageController pController;

  @override
  void initState() {
    super.initState();
    pController = new PageController(initialPage: widget._startPage, );
  }

  @override
  Widget build( BuildContext context ){
    return PageView.builder(
      itemBuilder: ( context, position ){
        return VocabDetailsUIPage( widget.vocablist[position], title: widget.vocablist[position].getWord() );
      },
      controller: pController,
      itemCount: widget.vocablist.length,
      scrollDirection: Axis.horizontal,
    );
  }


}