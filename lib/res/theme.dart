library custom_theme;

import 'package:flutter/material.dart';

var customThemeData = new ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.dark,
  primaryColor: Color(0xFFF7FFF7),
  accentColor:  Color(0xFF343434),


  // Define the default font family.
  fontFamily: 'Montserrat',

  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  )
);

const GREY = Color(0xFFDFE6DF);
const BLACK = Color(0xFF343434);
const WHITE = Color(0xFFF7FFF7);
const LIGHT_GREEN = Color(0xFF7BE495);
const GREEN = Color(0xFF56C596);
const TOMATO_RED = Color(0xFFE26D5A);