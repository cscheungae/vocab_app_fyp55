

import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;

/// Alignment of the Block
enum NavigationBlockAlignment {LtoR, RtoL}

/// Navigation Widget
class NavigationBlock extends StatelessWidget {

  /// Title of the NavigationBlock
  final String title;

  /// Body of the NavigationBlock
  final String body;

  /// Colors gradient
  final List<Color> colors;

  /// Direction of the widget
  final NavigationBlockAlignment direction;


  //Constructor
  NavigationBlock( {this.title = "", this.body = "", this.colors = CustomTheme.GREEN_GRADIENT_COLORS, this.direction = NavigationBlockAlignment.LtoR } );


  @override
  Widget build(BuildContext context) {
    return 
    ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: this.colors,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                this.title,
                textAlign: (this.direction == NavigationBlockAlignment.LtoR) ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  fontSize: 38.0,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              this.body,
              textAlign: (this.direction == NavigationBlockAlignment.LtoR) ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  height: 1.1
              ),
            ),
            Row(
              mainAxisAlignment: (this.direction == NavigationBlockAlignment.LtoR) ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                        this.direction == NavigationBlockAlignment.RtoL ? WidgetSpan(
                          child: Icon(Icons.arrow_left),
                        ) : TextSpan(text: ""), 
                        TextSpan(
                          text: "Learn More",
                          style: TextStyle( fontSize: 18, fontWeight: FontWeight.w400, height: 1.1),
                        ),
                        this.direction == NavigationBlockAlignment.LtoR ? WidgetSpan(
                          child: Icon(Icons.arrow_right),
                        ) : TextSpan(text: ""),
                    ] 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}


