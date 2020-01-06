import 'package:flutter/material.dart';
import '../pages/NewsWebViewPage.dart';
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
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  NewsWebViewPage(url: news.url,) )); 
        },
          child: Container(
            height: cardHeight,
            width: cardWidth,                 
            child: RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(text: news.description, style: TextStyle(fontSize: 18,) ),
            ),
          ),
      ),
    );
  }
}