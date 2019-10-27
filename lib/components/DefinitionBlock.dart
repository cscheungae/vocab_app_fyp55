
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//import '../res/theme.dart' as CustomTheme;


class DefinitionBlock extends StatelessWidget{

  final String header;
  final String body;

  const DefinitionBlock({ Key key, @required this.header, @required this.body }) : super(key: key);

  @override
  Widget build(BuildContext context){
    
    return
    Card( 
      elevation: 5.0,
      color: Colors.white,
  
      child: ExpansionTile(
          backgroundColor: Colors.white,
          initiallyExpanded: true,
          trailing: IconTheme( data: IconThemeData(color: Colors.black,), child: Icon(Icons.menu),  ),

          title: Text( header, 
            style: TextStyle(
                            color: Colors.blue, 
                            fontSize: 20, 
                            ),
          ),
          
          
          children: <Widget>[
            Container( child: Divider(color: Colors.black,),),

            Container(
              
              child: Text( this.body, 
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