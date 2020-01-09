import 'package:flutter/material.dart';
import '../util/manage_vocabbank.dart';
import '../model/vocabulary.dart';
import '../provider/vocabularyBank.dart';
import '../components/CustomBottomNavBar.dart';
import '../components/CustomAppBar.dart';
import '../components/CustomVocabCard.dart';
import '../components/CustomDrawer.dart';


import 'VocabFormPage.dart';
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
  //vocabs through UI
  List<vocabulary> _vocabList;

  bool allCardsVisible = true;   
  
  //search Constructor
  final TextEditingController _searchController = new TextEditingController();



  //initialize the vocab list 
  Future<List<vocabulary>> initVocabCardList( {forceUpdate = false} ) async
  {
    if (_vocabList == null || forceUpdate == true ){
      _vocabList = await VocabularyBank.instance.getVocabList();
      debugPrint( "total vocabs is " + _vocabList.length.toString());
    }

    return _vocabList;
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
                await VocabularyBank.instance.deleteAllVocabs(); 
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
        _vocabList = sortVocabListByWords( _vocabList );        
        break;
      case 1:
        Navigator.push(context,  MaterialPageRoute(builder: (context) => VocabFormPage() ) )
        .then((value) async { await initVocabCardList(forceUpdate: true); setState((){  });  }  );
        break;
      case 2:
          await _deleteAllVocabs();
          break;
      case 3: 
          await VocabularyBank.deleteDB();
          break;
      default: {}
    }
    setState(() {});
  }




  //Widget Building
  @override
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      appBar: CustomAppBar(title: "Vocabulary Bank", iconData: Icons.person),  
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
                onChanged: (query) async {

                  var vocabList = await VocabularyBank.instance.getVocabList(forceUpdate: false);
                  _vocabList =getSearchResultVocabList( vocabList, query.toLowerCase());
                  setState((){ });   
                },
                decoration: InputDecoration
                (
                  border: OutlineInputBorder ( borderSide: BorderSide(color: Colors.grey), ),
                  hintText: "Enter a Search Term",
                  suffixIcon: IconButton(
                    onPressed: () async { 

                      _searchController.clear(); 
                      _vocabList = await VocabularyBank.instance.getVocabList(forceUpdate: false); 
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
          child: FutureBuilder<List<vocabulary>>(
          future: initVocabCardList(),
            builder: ( context, AsyncSnapshot<List<vocabulary>> snapshot ){
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
      bottomNavigationBar: CustomBottomNavBar(),
      drawer: CustomDrawer(),
    );   
  } 
  
}