
/* a model class containing information about the news */
class News {
  String _id;
  String _name;
  String _description;
  String _url;
  String _category;
  String _language;
  String _country;

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get url => _url;
  String get category => _category;
  String get language => _language;
  String get country => _country;

  News({
    String id = "",
    String name = "",
    String description = "",
    String url = "",
    String category = "",
    String language = "",
    String country = "",
  }):
    this._id = id,
    this._name = name,
    this._description = description,
    this._url = url,
    this._category = category,
    this._language = language,
    this._country = country;

  
  factory News.fromJson(Map<String, dynamic> json) => new News(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    url: json["url"],
    category: json["category"],
    language: json["language"],
    country: json["country"],
  );


}
  

