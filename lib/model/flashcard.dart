import 'dart:ffi';
import 'package:vocab_app_fyp55/provider/providerConstant.dart';

class Flashcard {
  // Fields
  int vid; // foreign key
  int fid;
  DateTime dateLastReviewed;
  int daysBetweenReview;
  double overdue;
  double difficulty;

//  // Getter
//  int get vid => _vid;
//  DateTime get dateLastReviewed => _dateLastReviewed;
//  int get daysBetweenReview => _daysBetweenReview;
//  double get overdue => _overdue;
//  int get rating => _rating;
//
//  // Setter
//  set vid (vid) => _vid = vid;
//  set dateLastReviewed (date) => _dateLastReviewed = date;
//  set overdue(overdue) => _overdue = overdue;
//  set rating (rating) => _rating = rating;


  // Normal Constructor
  Flashcard({vid, fid, dateLastReviewed, daysBetweenReview, overdue, difficulty}) {
    this.vid = vid;   // cannot be null
    this.fid = fid ?? null;
    this.dateLastReviewed = dateLastReviewed ?? DateTime.now();
    this.daysBetweenReview = daysBetweenReview ?? 1;
    this.overdue = overdue ?? null;
    this.difficulty = difficulty ?? ProviderConstant.defaultDifficulty;
  }



  //Constructor, From Json to Dart Map Data
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      vid: json["vid"],
      fid: json["fid"],
      dateLastReviewed: DateTime.parse(json["dateLastReviewed"]),
      daysBetweenReview: json["daysBetweenReview"],
      difficulty: json["difficulty"],
      overdue: json["overdue"],
    );
  }

  // From Dart Map Data to Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "vid": vid,
      "fid": fid,
      "dateLastReviewed": dateLastReviewed.toIso8601String(),
      "daysBetweenReview": daysBetweenReview,
      "overdue": overdue, // TODO:: check if it will concatenate in the sqlite database
      "difficulty": difficulty
    };
    return json;
  }

  @override
  String toString() {
    return "Flashcard - (fid: $fid, vid: $vid, dateLashReviwed: ${dateLastReviewed.toIso8601String()}, daysBetweenReview: $daysBetweenReview, overdue: $overdue, difficulty: $difficulty)";
  }
}