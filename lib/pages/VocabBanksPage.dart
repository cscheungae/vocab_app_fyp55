import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';
import 'package:vocab_app_fyp55/components/CustomVocabCard.dart';
import 'package:vocab_app_fyp55/model/vocab.dart';
import 'package:vocab_app_fyp55/pages/VocabFormPage.dart';
//import 'package:vocab_app_fyp55/util/manage_vocabbank.dart';


import 'dart:async';



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
  /// vocabs through UI
  /// Note that it only takes [Vocab] instead of [VocabBundle]
  /// Convertion from Vocab to VocabBundle will only be performed later on
  List<Vocab> _vocabList;

  /// Determine whether all cards are visible
  bool allCardsVisible = true;   
  
  /// search Constructor
  final TextEditingController _searchController = new TextEditingController();



  //initialize the vocab list 
  Future<List<Vocab>> initVocabCardList( {forceUpdate = false} ) async
  {
    if (_vocabList == null || forceUpdate == true ){
      this._vocabList = await DatabaseProvider.instance.readAllVocab();
    }
    return this._vocabList;
  }


  
  @override
  void initState(){
    super.initState();
  }


  @override
  void dispose()
  {
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _deleteAllVocabs() async{
    showDialog(
      context: context,
      builder: (BuildContext context ){
        return AlertDialog(
          title: new Text("Delete All Vocabs"),
          content: new Text("Are you sure about that? "),
          actions: <Widget>[
            new FlatButton(
              child: Text("Close"),
              onPressed: (){Navigator.of(context).pop();},
            ),

            new FlatButton(
              child: Text("Accept"),
              onPressed: () async { 
                await DatabaseProvider.instance.deleteAllVocab(); 
                Navigator.of(context).pop();
                await initVocabCardList(forceUpdate: true);
                setState(() { });
              },
            )
          ]
        );
      }
    );

  }



  //Function for Selecting list item
  void _select(int choice) async
  {
    switch ( choice )
    {
      case 0: 
        //_vocabList = sortVocabListByWords( _vocabList );        
        break;
      case 1:
        Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabFormPage() ) )
        .then((value) async { await initVocabCardList(forceUpdate: true); setState((){  });  }  );
        break;
      case 2:
          await _deleteAllVocabs();
          break;
      case 3: 
          //await DatabaseProvider.instance.dropDatabase();
          break;
      default: {}
    }
    setState(() {});
  }




  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      body: Column
      (
        children: <Widget>[

        SafeArea( child: Container(), ),

        Row
        (
          children: <Widget>[
            SizedBox
            (
              width: MediaQuery.of(context).size.width * 0.72,
              height: MediaQuery.of(context).size.width * 0.15,
              
              child: Padding( padding: EdgeInsets.all(3) , child: TextField(
                controller: _searchController,
                onChanged: (query) async {

                  //TODO:  Filtering
                  //var vocabList = await DatabaseProvider.instance.getVocabList(forceUpdate: false);
                  //_vocabList = getSearchResultVocabList( vocabList, query.toLowerCase());
                  setState((){ });   
                },
                decoration: InputDecoration
                (
                  border: OutlineInputBorder ( borderSide: BorderSide(color: Colors.grey), ),
                  hintText: "Enter a Search Term",
                  suffixIcon: IconButton(
                    onPressed: () async { 
                      
                      //TODO:  Filtering
                      //_searchController.clear(); 
                      //_vocabList = await VocabularyBank.instance.getVocabList(forceUpdate: false); 
                      setState(() {});  
                    },
                    icon: Icon(Icons.clear),
                  )
                ), 
              ), ),
            ),
            

            /* For Changing all cards visibility */
            IconButton(
              onPressed: (){
                allCardsVisible = ! allCardsVisible;
                initVocabCardList();
                setState(() { });
              },
              icon: Icon(Icons.menu),
            ),


            PopupMenuButton<int>(
              onSelected: _select,
              itemBuilder: (context) => [
                PopupMenuItem(value: 0, child: Text("Sorted By Letters"),  ),
                PopupMenuItem(value: 1, child: Text("Add New Vocabulary"), ),
                PopupMenuItem(value: 2, child: Text("Delete All Vocabularies", style: TextStyle(color: Colors.red),), ),
                PopupMenuItem(value: 3, child: Text("Delete Database", style: TextStyle(color: Colors.red),), ),
              ],
            ),
          ],
        ),
        
        
        Expanded(
          child: FutureBuilder<List<Vocab>>(
          future: initVocabCardList(),
            builder: ( context, AsyncSnapshot<List<Vocab>> snapshot ){
              if ( snapshot.hasData )
              {
                return  ListView.builder
                (
                  itemCount: _vocabList.length,
                  itemBuilder: (context, position){                  
                    return CustomVocabCard(item: _vocabList[position], vocablist: _vocabList, isVisibleCardDescription: allCardsVisible,);
                  },
                );
              } else { return Center(child: CircularProgressIndicator()); } //no result
            }  
          ),
        ),
        

        ],
      ),
    );   
  } 
  
}