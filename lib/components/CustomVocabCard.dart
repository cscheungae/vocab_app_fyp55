import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/VocabDetailsPageView.dart';
import '../res/theme.dart' as CustomTheme;
import '../model/vocabulary.dart';
import '../pages/VocabDetailsPage.dart';


class CustomVocabCard extends StatefulWidget
{
  final vocabulary _item;
  final List<vocabulary> _vocablist;
  bool isVisibleCardDescription;


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

  /* Open a Page view if a _vocablist is provided and the item exists in such list
  Else, just open a vocab detail page */
  void openDetails(){
    
    if ( widget._vocablist.isEmpty || ! widget._vocablist.contains(widget.item) )
      Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsUIPage( widget.item, title: widget.item.getImageURL() ) ) );
    else
      Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsPageView(widget._vocablist, startPage: widget._vocablist.indexOf(widget.item) ) ) );
  }



  /* Return the Card Widget Structure of the vocabulary Card */
  Widget build(BuildContext context)
  { 
    final cardHeight = MediaQuery.of(context).size.height * 0.25;
    final cardWidth = MediaQuery.of(context).size.width;

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


