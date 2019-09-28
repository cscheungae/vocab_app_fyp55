import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import '../States/vocabularyState.dart';
import '../pages/VocabDetailsPage.dart';


class CustomVocabCard extends StatefulWidget
{
  vocabulary item;
  bool isVisibleCardDescription = true;
  
  
  CustomVocabCard({ Key key, this.item}): super(key: key);

  @override
  _CustomVocabCard createState() => _CustomVocabCard();
}

  

class _CustomVocabCard extends State<CustomVocabCard>
{
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
        onTap: (){ Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsUIPage( widget.item, title: widget.item.getImageURL() ) ) ); },
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
                    child: widget.item.getImage(),
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
                        widget.isVisibleCardDescription = ! widget.isVisibleCardDescription;
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


