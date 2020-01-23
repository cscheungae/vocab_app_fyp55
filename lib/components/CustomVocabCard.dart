import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/VocabDetailsPageView.dart';
import '../res/theme.dart' as CustomTheme;
import '../model/vocabulary.dart';
import '../pages/VocabDetailsPage.dart';

import '../util/Router.dart' as Router;

/// Widget containing data 
class CustomVocabCard extends StatefulWidget
{
  /// Vocab that will be displayed by the widget
  final vocabulary _item;

  /// An optional list of all other vocabularies can be supplied in the constructor (otherwise empty list)
  /// If supplied, [VocabDetailsPageView] will be opened, enabling swiping to navigate among [VocabDetailsUIPage] of other vocabularies
  final List<vocabulary> _vocablist;

  ///determines the visibility of the widget
  bool isVisibleCardDescription;

  ///getter of the vocabulary
  vocabulary get item => _item;


  //Constructor  
  CustomVocabCard({ Key key, vocabulary item, List<vocabulary> vocablist = const [], bool isVisibleCardDescription = true  }): 
  this._item = item,
  this._vocablist = vocablist,
  this.isVisibleCardDescription = isVisibleCardDescription,
  super(key: key);


  @override
  _CustomVocabCard createState() => _CustomVocabCard();

}

  

class _CustomVocabCard extends State<CustomVocabCard>
{
  /// Function determining how the vocab details page will be opened upon pressing the card itself
  /// See also: 
  /// * [_vocablist], which determines how the page will be opened
  void openDetails(){
    if ( widget._vocablist.isEmpty || ! widget._vocablist.contains(widget.item) ){
      Navigator.push(context, Router.AnimatedRoute(newWidget: VocabDetailsUIPage( widget.item, title: widget.item.getImageURL())  ));
      //Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsUIPage( widget.item, title: widget.item.getImageURL() ) ) );
    }
    else {
      Navigator.push(context, Router.AnimatedRoute(newWidget: VocabDetailsPageView(widget._vocablist, startPage: widget._vocablist.indexOf(widget.item))  ));
      //Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsPageView(widget._vocablist, startPage: widget._vocablist.indexOf(widget.item) ) ) );
    }
  }


  Widget build(BuildContext context)
  { 
    final double cardHeight = MediaQuery.of(context).size.height * 0.25;
    final double cardWidth = MediaQuery.of(context).size.width;
    return Card 
    (
      elevation: 7.0,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),  ),

      child: GestureDetector
      (
        onTap: openDetails,
        child: Wrap
        (
          children: <Widget>
          [
            /* FirstRow */
            Container
            (
              color: CustomTheme.WHITE,
              height: cardHeight * 0.30,
              width: cardWidth,
              alignment: Alignment.topLeft,

              child: Row(
                children: <Widget>[
                  Container
                  (
                    width: cardWidth * 0.35,
                    child: widget.item.getHeroImage(),
                  ),
                  
                  Container
                  ( 
                    alignment: Alignment.centerLeft,
                    width: cardWidth * 0.45,
                    child: Padding
                    (
                      padding: const EdgeInsets.all(10.0),
                      child: Text
                      (
                        widget.item.getWord(),  
                        style: TextStyle( 
                          fontSize: 20.0, 
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.BLACK, 
                        ),
                      ),
                    ), 
                  ),
                      
                  Expanded 
                  (
                    child: IconButton( 
                      icon: Icon(Icons.menu,),
                      color: Colors.black, 
                      onPressed:(){  setState(() {  
                        widget.isVisibleCardDescription = (! widget.isVisibleCardDescription );
                      });  },  
                    ), 
                  ),
                ],
              ),
            ),
          

            Visibility
            (
              visible: widget.isVisibleCardDescription,
              child: Container
              (
                decoration: new BoxDecoration
                ( 
                  color: Color.fromRGBO(200, 200, 250, 0.6),
                  //borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
                ),
                alignment: Alignment.topLeft,
                height: cardHeight * 0.75,
                width: cardWidth,
                child: Text( "Hello Everyone this is a lovely vocab card description about " + widget.item.getWord() + ", you can learn more about it in here",  ),               
              ),
            ),

          ],
        ),
      ),
    );    
  }
}


