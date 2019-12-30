import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;

class DismissibleBlock extends StatelessWidget {

  final Color bgColor;
  final String text;

  DismissibleBlock( { Color color = CustomTheme.GREEN, String text = "" } ) : 
  this.bgColor = color,
  this.text = text;
  
  @override
  Widget build(BuildContext context) {
    return 
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: bgColor,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text( text,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                ),
                FlatButton(
                  onPressed: (){},
                  child:  Icon(
                    Icons.close,color: CustomTheme.WHITE, size: 25.0,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }


}
