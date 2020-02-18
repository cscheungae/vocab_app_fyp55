import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;

class DismissibleBlock  extends StatefulWidget {

  final Color bgColor;
  final String text;

  DismissibleBlock({ Color color = CustomTheme.GREEN, String text = "", bool visibility = true }) :
  bgColor = color,
  text = text;

  @override
  _DismissibleBlock createState() => _DismissibleBlock();
}



class _DismissibleBlock extends State<DismissibleBlock> {

  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return 
      visibility ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: widget.bgColor,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text( widget.text,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    )
                ),
                FlatButton(
                  onPressed: (){ setState(() {
                    print("PRESSED CLOSE");
                    visibility = false;
                  }); },
                  child:  Icon(
                    Icons.close,color: CustomTheme.WHITE, size: 25.0,
                  ),
                ),
              ],
            ),
          ),
        )
    ) : Container();
  }


}
