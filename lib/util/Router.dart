
import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget newWidget;
  
  AnimatedRoute({ this.newWidget, }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => newWidget,
    transitionDuration: Duration(milliseconds: 450),
    transitionsBuilder: ( context, animation, secondaryAnimation, child){
      
      var curve = Curves.decelerate;  
      var begin = Offset(0, 1);
      var end = Offset.zero;
      var tween = Tween( begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition( 
        position: tween.animate(animation),
        child: newWidget,
      );
      
    }
  );

}
