import 'dart:convert';

import 'package:vocab_app_fyp55/model/Genre.dart';

class User {
  // Field
  int uid;
  String name;
  String password;
  int trackThres;
  int wordFreqThres;
  String region;  // "gb" or "us"
  List<String> genres;

  // Constructor
  User({this.uid, this.name, this.password, this.trackThres = 2, this.wordFreqThres = 4, this.region = "gb",
    this.genres = const [
      "business",
      "entertainment",
      "general",
      "health",
      "science",
      "sports",
      "technology"
    ]});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      uid: json["uid"],
      name: json["name"],
      password: json["password"],
      trackThres: json["trackThres"],
      wordFreqThres: json["wordFreqThres"],
      region: json["region"],
      genres: jsonDecode(json["genres"]).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "password": password,
      "trackThres": trackThres,
      "wordFreqThres": wordFreqThres,
      "region": region,
      "genres": jsonEncode(genres)
    };
  }

  void setTrackThres(int trackThres) {
    this.trackThres = trackThres;
  }

  void setWordFreqThres(int wordFreqThres) {
    this.wordFreqThres = wordFreqThres;
  }

  void setRegion(String region) {
    this.region = region;
  }

  void setGenres(List<String> genres) {
    this.genres = genres;
  }
}