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
      sid: json["sid"] ?? null,
      logDate: json["logDate"]!= null ? DateTime.parse(json["logDate"]) : null,
      trackingCount: json["trackingCount"] ?? null,
      learningCount: json["learningCount"] ?? null,
      maturedCount: json["maturedCount"] ?? null,
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

  @override
  String toString() {
    return "Stat - sid: $sid, logDate: ${logDate.toIso8601String()}, trackingCount: $trackingCount, learningCount: $learningCount, maturedCount: $maturedCount";
  }
}