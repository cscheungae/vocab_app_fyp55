class UserBundle {
  // Field
  int uid;
  String name;
  int trackThres = 2;
  int wordFreqThres = 4;
  String region = "gb";  // "gb" or "us"
  List<String> genreBundle;

  // Constructor
  UserBundle({this.uid, this.name, this.trackThres, this.wordFreqThres, this.region, this.genreBundle});
}