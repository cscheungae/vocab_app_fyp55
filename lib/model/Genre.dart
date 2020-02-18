class Genre {
  // Fields
  int uid; // Foreign key to user
  int gid;
  String category;

  // Constructor
  Genre({this.uid, this.gid, this.category});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return new Genre(
      uid: json["uid"],
      gid: json["gid"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "gid": gid,
      "category": category,
    };
  }
}