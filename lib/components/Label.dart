/// credit: https://github.com/google/charts/issues/266

import 'package:flutter/material.dart';

class DrawLine extends CustomPainter {
  final Color color;
  final Offset from;
  final Offset to;
  DrawLine(this.color, this.from, this.to);

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Label extends StatelessWidget {
  final String _label;
  final Color _color;
  Label(this._label, this._color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 25),
        Text(_label, style: TextStyle(fontSize: 13)),
        Container(
          width: 75,
          height: 10,
          child: CustomPaint(
            size: Size(100, 100),
            painter: DrawLine(
              _color,
              Offset(10, 0),
              Offset(50, 0),
            ),
          ),
          padding: EdgeInsets.all(8),
        ),
      ],
    );
  }
}