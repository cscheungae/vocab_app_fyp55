import 'package:flutter/material.dart';
import '../services/fetchdata_Datamuse.dart';
import '../services/fetchimage_Bing.dart';
import '../util/manage_vocabbank.dart';
import '../util/vocabulary.dart';
import 'VocabDetailsPage.dart';
import '../components/CustomBottomNavBar.dart';
import '../components/CustomAppBar.dart';
import '../res/theme.dart' as CustomTheme;



import 'dart:async';
import 'dart:math';


class VocabCardUIPage extends StatefulWidget 
{
  final String title;

  //Constructor
  VocabCardUIPage( {Key key, this.title}  ) : super( key: key);

  @override
  _VocabCardPage createState() => _VocabCardPage();
}



class _VocabCardPage extends State<VocabCardUIPage>
{
  String _searchResult = "";
  List<vocabulary> _vocabList = [ ];  //whole list of vocabs, unaltered
  List<vocabulary> _visibleVocabList = [];   //actual visible vocab through UI
  Map<String, bool> _isVisibleCardDescript = {};  //Check Hided Description
  
  final TextEditingController _searchController = new TextEditingController();
  

  //Upon creation
  @override
  void initState()
  {
    super.initState();

    _vocabList.add(new vocabulary(word: "Orange") );
    _vocabList.add(new vocabulary(word: "Apple") );
    _vocabList.add(new vocabulary(word: "Melon") );
    _vocabList.add(new vocabulary(word: "Apple1") );
    _vocabList.add(new vocabulary(word: "Orange1") );
    _vocabList.add(new vocabulary(word: "Zebra") );

    _visibleVocabList = _vocabList;

    for ( var item in _visibleVocabList )
    {
      _isVisibleCardDescript[item.getWord()] = true;
    }
  }


  //Function for Selecting list item
  void _select(int choice)
  {
    setState(() {
      switch ( choice )
      {
        case 0: 
          _visibleVocabList = sortVocabListByWords( _visibleVocabList );
          _vocabList = sortVocabListByWords( _vocabList );
          break;
        default: {}
      }
    });
  }



  //Widget Building
  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      appBar: CustomAppBar(title: "home", iconData: Icons.person),  
      body: Column
      (
        children: <Widget>[

        Row
        (
          children: <Widget>[
            SizedBox
            (
              width: MediaQuery.of(context).size.width * 0.72,
              height: MediaQuery.of(context).size.width * 0.15,
              

              child: Padding( padding: EdgeInsets.all(3) , child: TextField(
                controller: _searchController,
                onChanged: (query){  setState(() {
                  _visibleVocabList = getSearchResultVocabList( _vocabList, query.toLowerCase() );
                });   },
                decoration: InputDecoration
                (
                  border: OutlineInputBorder ( borderSide: BorderSide(color: Colors.grey), ),
                  hintText: "Enter a Search Term",
                  suffixIcon: IconButton(
                    onPressed: (){ _searchController.clear(); _visibleVocabList = _vocabList; },
                    icon: Icon(Icons.clear),
                  )
                ), 
              ), ),
            ),
            
            IconButton(
              onPressed: (){
                setState(() {
                  for ( var item in _vocabList )
                    _isVisibleCardDescript[item.getWord()] = !_isVisibleCardDescript[item.getWord()];           
                });
              },
              icon: Icon(Icons.menu),
            ),

            PopupMenuButton<int>(
              onSelected: _select,
              itemBuilder: (context) => [
                PopupMenuItem(value: 0, child: Text("Sorted By Letters"),  ),
                PopupMenuItem(value: 1, child: Text("Hello World"), ),
              ],
            ),
          ],
        ),
        
        Expanded( child: ListView.builder
        (
          itemCount: _visibleVocabList.length,
          itemBuilder: (context, position){
            return getCardStructure( _visibleVocabList[position], context );
          },
        ),),
        
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(index: 0,),
    );   
  } 

  




  /* Return the Card Widget Structure of the vocabulary Card */
  /* Wrong Vocab Card */
  Card getCardStructure( vocabulary item, BuildContext context,  )
  { 
    final cardHeight = MediaQuery.of(context).size.height * 0.25;
    final cardWidth = MediaQuery.of(context).size.width;  

    return Card 
    (
      elevation: 7.0,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),  ),

      child: GestureDetector
      (
        onTap: (){ Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabDetailsUIPage( item, title: item.getImageURL() ) ) ); },
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
                    child: item.getImage(),
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
                        item.getWord(),  
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
                      onPressed:(){  setState(() {
                       _isVisibleCardDescript[item.getWord()] = ! _isVisibleCardDescript[item.getWord()];
                      });  },  
                    ), 
                  ),
                ],
              ),
            ),
          

            Visibility
            (
              visible: _isVisibleCardDescript[item.getWord()],
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
                child: Text( "Hello Everyone this is a lovely vocab card description about " + item.getWord() + ", you can learn more about it in here",  ),               
              ),
            ),

          ],
        ),

      ),
    );
  }
  
}