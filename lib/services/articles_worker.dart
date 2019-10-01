import 'package:meta/meta.dart';

class ArticlesWorker {
  Future<List<String>> fetch({@required List<String> categories}) {
    return Future.delayed(Duration(seconds: 4), () => [
      'Article A',
      'Article B',
      'Article C'
    ]);
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