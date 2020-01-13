class Example {
  // Field
  int eid;
  int did; // foreign key to definition
  String sentence;

  // Normal Constructor
  Example({this.eid, this.did, this.sentence});

  //Constructor, From Json to Dart Map Data
  factory Example.fromJson( Map<String, dynamic> json ){
    return Example(
      eid: json["eid"],
      did: json["did"] ?? null,
      sentence: json["sentence"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "eid": eid,
      "did" : did,
      "sentence" : sentence,
    };
  }
}