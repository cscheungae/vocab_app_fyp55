import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../pages/NewsWebViewPage.dart';
import '../model/news.dart';

/// Widget displaying the news information
class CustomNewsCard extends StatelessWidget {
  /// News to be displayed
  final NewsItem newsItem;

  ///Constructor
  ///[news] - required
  CustomNewsCard(NewsItem news) : this.newsItem = news;

  String _parsedate(DateTime dateTime) {
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();
    String month;
    switch (dateTime.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "Feburary";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
      default:
        month = "January";
        break;
    }
    return "$day $month $year";
  }

  @override
  Widget build(BuildContext context) {
//    Remove these two fixed constraints
//    final cardHeight = MediaQuery.of(context).size.height * 0.40;
//    final cardWidth = MediaQuery.of(context).size.width;

    return new Card(
      elevation: 3.0,
      child: GestureDetector(
        onTap: () {
          print("Open WebView for " + newsItem.url);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsWebViewPage(
                        url: newsItem.url,
                      )));
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.black54, width: 3.0))
                    ),
                    child: Text(
                      newsItem.press,
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.black54),
//                        color: Colors.red,
                    ),
                    child: Text(
                      newsItem.category[0].toUpperCase() +
                          newsItem.category.substring(1),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: newsItem.title,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child: Icon(Icons.create, color: Colors.black26,),
                  ),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: newsItem.author,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child: Icon(Icons.timelapse, color: Colors.black26,),
                  ),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: _parsedate(DateTime.parse(newsItem.publishedAt)),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 10.0),
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: newsItem.description,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
