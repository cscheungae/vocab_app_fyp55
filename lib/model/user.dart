import 'package:vocab_app_fyp55/model/Genre.dart';

import 'package:vocab_app_fyp55/model/Genre.dart';

class User {
  // Field
  int uid;
  String name;
  int trackThres = 2;
  int wordFreqThres = 4;
  String region = "gb";  // "gb" or "us"

  // Constructor
  User({this.uid, this.name, this.trackThres, this.wordFreqThres, this.region});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      uid: json["uid"],
      name: json["name"],
      trackThres: json["trackThres"],
      wordFreqThres: json["wordFreqThres"],
      region: json["region"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "trackThres": trackThres,
      "wordFreqThres": wordFreqThres,
      "region": region,
    };
  }
}