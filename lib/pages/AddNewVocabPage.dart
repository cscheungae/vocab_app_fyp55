import 'package:flutter/material.dart';
import '../States/vocabularyState.dart';
import '../res/theme.dart' as CustomTheme;

import '../States/vocabularyBankState.dart';

class AddNewVocabPage extends StatefulWidget
{
  final String title;
  
  //Constructor
  AddNewVocabPage( {Key key, this.title,}) : super(key: key);

  @override
  _AddNewVocabPage createState() => _AddNewVocabPage();
}

class _AddNewVocabPage extends State <AddNewVocabPage>
with AutomaticKeepAliveClientMixin
{  
  final _formKey = GlobalKey();
  final _textWordController = TextEditingController();
  
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose(){
    _textWordController.dispose();
    super.dispose();
  }

  @override 
  Widget build( BuildContext context )
  {
    return Scaffold
    (
      backgroundColor: Colors.white,
      body: Column
      (
        children: <Widget>
        [
          Container
          (
            height: MediaQuery.of(context).size.height * 0.10,
            child: AppBar
            (
              title: Text("Adding New Vocabulary" ),
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
              elevation: 0, 
            ),
          ),

          Padding
          (
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Form
            (
              key: _formKey,
              child: Column(children: <Widget>
                [      
                  Card
                  (
                    color: Colors.blue[100],
                    child: TextFormField(
                      controller: _textWordController,
                      validator: (value){
                        if (value.isEmpty){ return "Please Enter the Keyword"; } return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter The Word",
                      ),
                    ),
                  ),

              
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
          Navigator.pop(context);
        },
      ),

    );
  }
}