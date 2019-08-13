import 'package:flutter/material.dart';
import '../res/theme.dart' as CustomTheme;
import '../components/CustomAppBar.dart';

class ArticlesViewPage extends StatefulWidget {
  ArticlesViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ArticlesViewPageState createState() => _ArticlesViewPageState();
}

class _ArticlesViewPageState extends State<ArticlesViewPage> {
  // out the widget's state here

  @override
  Widget build(BuildContext context) {
    //TODO: implement
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                    child: Text(
                      articles[index]["title"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
                    child: Text(
                      articles[index]["excerpt"],
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, bottom: 6.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/articles'),
                          textColor: CustomTheme.WHITE,
                          color: CustomTheme.GREEN,
                          child: Text(
                              articles[index]["media"] +
                                  " | " +
                                  articles[index]["category"],
                              style: TextStyle(fontSize: 14.0)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

//sample articles source
const articles = [
  {
    "title": "Gunman kills 20 in rampage at Texas Walmart store",
    "excerpt":
        "A gunman armed with a rifle killed 20 people at a Walmart in El Paso and wounded more than two dozen before being arrested, after the latest U.S. mass shooting sent panicked shoppers fleeing.",
    "media": "Reuter",
    "category": "news"
  },
  {
    "title": "Saeed Malekpour: Web designer escapes life sentence in Iran",
    "excerpt":
        "Saeed Malekpour fled to Canada via a third country while on short-term release from jail.",
    "media": "BBC",
    "category": "news"
  }
];
