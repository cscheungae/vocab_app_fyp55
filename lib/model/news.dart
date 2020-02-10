
/* a model class containing information about the news */
class NewsItem {
  String _press;
  String _author;
  String _title;
  String _description;
  String _url;
  String _category;
  String _publishedAt;

  String get press => _press;
  String get author => (_author == null) ? "Anonymous" : _author;
  String get title=> _title;
  String get description => _description;
  String get url => _url;
  String get category => (_category == null) ? "General" : _category;
  String get publishedAt => _publishedAt;

  NewsItem({
    String press,
    String author,
    String title,
    String description = "",
    String url = "",
    String category = "",
    String publishedAt,
  }):
      this._press = press,
    this._author = author,
    this._title = title,
    this._description = description,
    this._url = url,
    this._category = category,
    this._publishedAt = publishedAt;

  
  factory NewsItem.fromJson(Map<String, dynamic> json) => new NewsItem(
    press: json["source"]["name"],
    author: json["author"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    category: json["category"],
    publishedAt: json["publishedAt"],
  );


}
  

