class StatResponse {
  int uid;
  int sid;
  String username;
  DateTime logDate;
  int learningCount;
  int matureCount;
  int trackingCount;
  int ranking;

  StatResponse({int uid, int sid, String username, DateTime logDate, int learningCount, int matureCount, int trackingCount, int ranking}) {
    this.uid = uid;
    this.sid = sid;
    this.username = username;
    this.logDate = logDate;
    this.learningCount = learningCount;
    this.matureCount = matureCount;
    this.trackingCount = trackingCount;
    this.ranking = ranking;
  }

  factory StatResponse.fromJson(Map<String, dynamic> json) => new StatResponse(
    uid: json['uid'],
    sid: json['sid'],
    username: json['name'],
    logDate: DateTime.parse(json['log_date']),
    learningCount: json['learningCount'],
    matureCount: json['matureCount'],
    trackingCount: json['trackingCount'],
    ranking: json['ranking'],
  );
}
