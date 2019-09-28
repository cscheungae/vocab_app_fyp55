import 'package:flutter/material.dart';
import '../services/fetchdata_Datamuse.dart';
import '../services/fetchimage_Bing.dart';
import '../util/manage_vocabbank.dart';

import '../States/vocabularyState.dart';
import '../States/vocabularyBankState.dart';

import 'VocabDetailsPage.dart';
import '../components/CustomBottomNavBar.dart';
import '../components/CustomAppBar.dart';
import '../components/CustomVocabCard.dart';

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
   String _searchResult = ""; //Search Input

  vocabularyBankState bank = new vocabularyBankState();
  List<CustomVocabCard> _VocabCardList = [];   //actual visible vocabs through UI
  
  final TextEditingController _searchController = new TextEditingController();


  void UpdateVocabCardList( List<vocabulary> vocablist)
  {
    _VocabCardList = [];
    for ( var vocab in vocablist )
      _VocabCardList.add( new CustomVocabCard(item:vocab) );
  }

  
  //Upon creation
  @override
  void initState()
  {
    super.initState();
    bank.debugAddVocabs();
    UpdateVocabCardList(bank.vocabList);
  }


  //Function for Selecting list item
  void _select(int choice)
  {
    setState(() {
      switch ( choice )
      {
        case 0: 
          bank.vocabList = sortVocabListByWords( bank.vocabList );
          UpdateVocabCardList(bank.vocabList);
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
                  List<vocabulary> searchResultVocabList = getSearchResultVocabList( bank.vocabList, query.toLowerCase() );
                  UpdateVocabCardList(searchResultVocabList);
                });   },
                decoration: InputDecoration
                (
                  border: OutlineInputBorder ( borderSide: BorderSide(color: Colors.grey), ),
                  hintText: "Enter a Search Term",
                  suffixIcon: IconButton(
                    onPressed: (){ _searchController.clear(); UpdateVocabCardList(bank.vocabList); },
                    icon: Icon(Icons.clear),
                  )
                ), 
              ), ),
            ),
            
            IconButton(
              onPressed: (){
                setState(() {
                  for ( var VocabCard in _VocabCardList ){
                    VocabCard.isVisibleCardDescription = ! VocabCard.isVisibleCardDescription; //Won't work 
                  }     
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
          itemCount: _VocabCardList.length,
          itemBuilder: (context, position){
            return _VocabCardList[position];
          },
        ),),
        
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(index: 0,),
    );   
  } 
  
}