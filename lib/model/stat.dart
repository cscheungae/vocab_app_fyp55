class Stat {
  // Field
  int sid;
  DateTime logDate;
  int trackingCount;
  int learningCount;
  int maturedCount;

  // Normal Constructor
  Stat({this.sid, this.logDate, this.trackingCount, this.learningCount, this.maturedCount});

  //Constructor, From Json to Dart Map Data
  factory Stat.fromJson( Map<String, dynamic> json ){
    return Stat(
      logDate: json["logDate"]!= null ? DateTime(json["logDate"]) : null,
      trackingCount: json["trackingCount"] ?? "",
      learningCount: json["learningCount"] ?? "",
      maturedCount: json["maturedCount"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "logDate" : logDate.toIso8601String(), // TODO:: Issue - is it problematic not to parse the datetime object into string
      "trackingCount" : trackingCount,
      "learningCount" : learningCount,
      "maturedCount" : maturedCount,
    };
  }
}