
import 'package:vocab_app_fyp55/components/CustomAppBar.dart';
import 'package:vocab_app_fyp55/components/CustomBottomNavBar.dart';
import '../components/CustomDrawer.dart';
import '../res/theme.dart' as CustomTheme;
import '../provider/vocabularyBank.dart';
import '../model/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';



class StudyPage extends StatefulWidget {
  StudyPage({Key key}) : super(key: key);

  @override
  _StudyPage createState() => _StudyPage();
}





class _StudyPage extends State<StudyPage> {

  //vocabs through UI
  List<vocabulary> _vocabList;

  //initialize the vocab list 
  Future<List<vocabulary>> initVocabCardList( {forceUpdate = false} ) async
  {
    if (_vocabList == null || forceUpdate == true )
      _vocabList = await vocabularyBank.instance.getVocabList();
    
    return _vocabList;
  }



  Widget build(BuildContext context){
    return Scaffold(
        appBar: CustomAppBar(title: "Study Mode",),
        
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Text(""),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: CustomTheme.GREEN,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            "Words that will be tested are as follows:",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              )
           ),

            Text(""),

            FutureBuilder<List<vocabulary>>(
              future: initVocabCardList(),
              builder: ( context, AsyncSnapshot<List<vocabulary>> snapshot ){
                if ( snapshot.hasData )
                {
                  return 
                  Container(
                    child: Tags(
                      itemCount: _vocabList.length,
                      columns: 4,
                      itemBuilder: (position){
                        return ItemTags(
                          index: position,
                          title: _vocabList[position].getWord(),
                          textStyle: TextStyle(fontSize: 18),
                        );
                      },
                    )
                  );
                } else { return Center(child: CircularProgressIndicator()); } //no result
              }
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                          color: CustomTheme.TOMATO_RED,
                          child: Text("Back"),
                          onPressed: (){print("You touched me to back!");}
                        ),
                      ),
                      Container (
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder( borderRadius: new BorderRadius.circular(5), ),
                          color: CustomTheme.LIGHT_GREEN,
                          child: Text("Start"),
                          onPressed: (){ print("You touched me to start!"); },
                        ),
                      )
                ],),
              ),
            ),

          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(),   
        drawer: CustomDrawer(),
    );
  }

}