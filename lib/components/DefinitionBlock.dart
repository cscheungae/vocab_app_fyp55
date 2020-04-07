import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// A custom widget of expansion tiles storing detailed info, specifically vocabularies definition
/// Commonly used in [VocabDetailsUIPage]
class DefinitionBlock extends StatelessWidget{

  /// header of the expansion tile
  final String header;

  /// body of the expansion tile
  final String body;

  //initial expand
  final bool initiallyExpanded;

  /// Constructor
  /// [header] - required
  /// [body] - required
  const DefinitionBlock({ Key key, @required this.header, @required this.body, this.initiallyExpanded = true }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return
    Card( 
      elevation: 5.0,
      color: Colors.white,
      child: ExpansionTile(
          backgroundColor: Colors.white,
          initiallyExpanded: this.initiallyExpanded,
          trailing: IconTheme( data: IconThemeData(color: Colors.black,), child: Icon(Icons.menu), ),
          title: Text( header ?? "null", 
            style: TextStyle(
              color: Colors.blue, 
              fontSize: 20, 
              ),
          ),
          /// body
          children: <Widget>[
            Container( child: Divider(color: Colors.black,),),
            Container(
              child: Text( this.body ?? "null", 
              style: TextStyle(
                color: Colors.black, 
                fontSize: 18, 
                ),
              ),
            ),
            Container( child: Text(" ")),
          ],
      ),
    );
  }
}