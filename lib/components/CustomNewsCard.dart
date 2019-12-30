import 'package:flutter/material.dart';
import 'package:vocab_app_fyp55/pages/LoginPage.dart';
import '../model/news.dart';

class CustomNewsCard extends StatelessWidget{

  final news;

  CustomNewsCard(News news): news = news;

  @override
  Widget build(BuildContext context){
    final cardHeight = MediaQuery.of(context).size.height * 0.20;
    final cardWidth = MediaQuery.of(context).size.width;

    return new Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),  ),

      child: GestureDetector(
        onTap: (){ 
          print("Open WebView for " + news.url); 
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); 
        },
        child: Container(
          height: cardHeight,
          width: cardWidth, 
          child: Row(
            children: <Widget>[
              Text(
                news.description,
                style: TextStyle(fontSize: 15),
              ),

              Text("by " + news.name),
            ],
          ),
        ),
      ),
    );
  }
}