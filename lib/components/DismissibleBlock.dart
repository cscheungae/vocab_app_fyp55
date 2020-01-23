import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;


class DismissibleBlock extends StatefulWidget {

  /// Background color of the widget
  final Color bgColor;

  /// Text dscription inside the widget
  final String text;

  /// Determine whether such widget can be seen
  /// Note that this value only affects the INITIAL visibility of the widget
  /// [visibility] inside [_DismissibleBlock] is what truly determines the visibility state
  final bool initVisibility;


  /// Constructor of the widget
  /// [bgColor] - default to [CustomTheme.GREEN] color
  /// [text] - default to empty string
  /// [initVisibility] - default to true
  DismissibleBlock({ this.bgColor = CustomTheme.GREEN, this.text = "",  this.initVisibility = true });


  @override
  _DismissibleBlock createState() => _DismissibleBlock(initVisibility);
}


/// State of [DismissibleBlock] widget
class _DismissibleBlock extends State<DismissibleBlock> {

  /// visibility of the widget
  bool visibility;

  ///Constructor
  ///[visibility] - default true, based on the initVisibility in [DismissibleBlock]
  _DismissibleBlock(this.visibility);


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
