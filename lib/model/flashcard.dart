import 'dart:ffi';

class Flashcard {
  // Fields
  int vid; // foreign key
  int fid;
  DateTime dateLastReviewed;
  int daysBetweenReview;
  double overdue;
  int rating;

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
  Flashcard({vid, fid, dateLastReviewed, daysBetweenReview, rating}) {
    this.vid = vid ?? null;
    this.fid = fid ?? null;
    this.dateLastReviewed = dateLastReviewed ?? DateTime.now();
    this.daysBetweenReview = daysBetweenReview ?? 1;
    this.rating = rating ?? 0;
  }

  //Constructor, From Json to Dart Map Data
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      vid: json["vid"],
      fid: json["fid"],
      dateLastReviewed: DateTime(json["dateLastReviewed"]),
      daysBetweenReview: json["daysBetweenReview"],
      rating: json["rating"],
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
      "rating": rating
    };
    return json;
  }
}