import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/model/flashcard.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/pages/VocabDetailsPageView.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/res/theme.dart' as CustomTheme;
import 'package:vocab_app_fyp55/pages/VocabDetailsPage.dart';
import 'package:vocab_app_fyp55/util/Router.dart' as Router;

/// Widget containing data 
class CustomVocabCard extends StatefulWidget
{
  /// Vocab that will be displayed by the widget
  final Vocab _item;

  /// An optional list of all other vocabularies can be supplied in the constructor (otherwise empty list)
  /// If supplied, [VocabDetailsPageView] will be opened, enabling swiping to navigate among [VocabDetailsUIPage] of other vocabularies
  final List<Vocab> _vocablist;

  ///determines the visibility of the widget
  bool isVisibleCardDescription;

  ///getter of the vocabulary
  Vocab get item => _item;


  //Constructor  
  CustomVocabCard({ Key key, Vocab item, List<Vocab> vocablist = const [], bool isVisibleCardDescription = true  }): 
  this._item = item,
  this._vocablist = vocablist,
  this.isVisibleCardDescription = isVisibleCardDescription,
  super(key: key);


  @override
  _CustomVocabCard createState() => _CustomVocabCard();

}

  

class _CustomVocabCard extends State<CustomVocabCard>
{
  //Theme
  int theme = 0;

  bool isDeleted = false;

  ///Image related
  Image placeholderImage;
  static List<Image> cardImgs = [cardImg1, cardImg2, cardImg3, cardImg4, cardImg5 ];
  static Image cardImg1;
  static Image cardImg2;
  static Image cardImg3;
  static Image cardImg4;
  static Image cardImg5;

  List<Color> bgColors = [
    Colors.purple[200],
    Colors.lightGreen,
    Colors.orange[300],
    Colors.lightBlue[200],
    Colors.redAccent[100]
  ];
  


  @override
  void initState() {
    super.initState();
    placeholderImage = Image( image: AssetImage("assets/initialAddVocab.jpg"), fit: BoxFit.cover,);  
    cardImg1 = Image(image: AssetImage("assets/cardImg1.png"), fit: BoxFit.cover,);
    cardImg2 = Image(image: AssetImage("assets/cardImg2.png"), fit: BoxFit.cover,);  
    cardImg3 = Image(image: AssetImage("assets/cardImg3.png"), fit: BoxFit.cover,);  
    cardImg4 = Image(image: AssetImage("assets/cardImg4.png"), fit: BoxFit.cover,);  
    cardImg5 = Image(image: AssetImage("assets/cardImg5.png"), fit: BoxFit.cover,);  

    
    theme = widget._item.word.codeUnitAt(0) % 5 ;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(placeholderImage.image, context);
    precacheImage(cardImg1.image, context);
    precacheImage(cardImg2.image, context);
    precacheImage(cardImg3.image, context);
    precacheImage(cardImg4.image, context);
    precacheImage(cardImg5.image, context);
  }


  ///getFlashCard
  Future<Flashcard> initFlashCard(int vid) async{
    return (await DatabaseProvider.instance.readFlashcard(vid));
  }


  /// Function determining how the vocab details page will be opened upon pressing the card itself
  /// See also: 
  /// * [_vocablist], which determines how the page will be opened
  void openDetails(){
    if ( widget._vocablist.isEmpty || ! widget._vocablist.contains(widget.item) ){
      List<Vocab> list = [widget._item]; 
      Navigator.push(context, Router.AnimatedRoute(newWidget: VocabDetailsPageView( list , startPage: 0)  ))
      .then((value){
        setState(() {
          if (value == "delete")
            isDeleted = true;
        });
      });
    }
    else {
      Navigator.push(context, Router.AnimatedRoute(newWidget: VocabDetailsPageView( widget._vocablist, startPage: widget._vocablist.indexOf(widget.item))  ))
      .then((value){
        setState(() {
          if (value == "delete")
            isDeleted = true;
        });
      });
    }
  }


  //Get Image
  Widget getImage(Vocab vocab){
    return new CachedNetworkImage(
      imageUrl: vocab.imageUrl,
      placeholder: (context, url) => this.placeholderImage,
      fit: BoxFit.cover,
    );
  }


  Widget build(BuildContext context)
  { 
    final double cardHeight = MediaQuery.of(context).size.height * 0.25;
    final double cardWidth = MediaQuery.of(context).size.width;

    final TextStyle textStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    );

    return isDeleted ? Container() : Card 
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
                    child: getImage(widget.item),
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
                        widget.item.word,  
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
          

            //Description
            AnimatedContainer
            (
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              decoration: new BoxDecoration
              ( 
                color: this.bgColors[theme],
                borderRadius: new BorderRadius.only( bottomLeft: const Radius.circular(10.0), bottomRight:const Radius.circular(10.0)  ),
              ),
              alignment: Alignment.topLeft,
              height: cardHeight * 0.75 * ((widget.isVisibleCardDescription) ? 1 : 0),
              width: cardWidth,
              child: Stack(children: <Widget>[
                Container(
                  height: cardHeight * 0.75 * ((widget.isVisibleCardDescription) ? 1 : 0),
                  width: cardWidth,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.only( bottomLeft: const Radius.circular(10.0), bottomRight:const Radius.circular(10.0)  ), 
                    child: Opacity( 
                      child: cardImgs[theme],
                      opacity: 0.12,
                    ),
                  ),
                ),

                
                  
                FutureBuilder<Flashcard>(
                  future: initFlashCard(widget.item.vid),
                  builder: (BuildContext context, AsyncSnapshot<Flashcard> snapshot) {
                    if (snapshot.hasData){
                      if (snapshot.data == null )
                        return Container();

                      return Wrap(
                        runSpacing: 5.0,
                        children: <Widget>[
                          Text("flash card last reviewed since:", style: textStyle,  ),
                          Text(snapshot.data.dateLastReviewed.toString().split('.')[0], style: textStyle, ),
                          Text("will be reviewed on a basis of: " + snapshot.data.daysBetweenReview.toString() + " day(s)", style: textStyle, ),
                        ],
                      );
                    }
                    else return Container();
                  },
                ),
                

              ],)            
            ),
            

          ],
        ),
      ),
    );    
  }
}


