class Example {
  // Field
  int eid;
  int did; // foreign key to definition
  String sentence;

  // Normal Constructor
  Example({this.did, this.sentence});

  //Constructor, From Json to Dart Map Data
  factory Example.fromJson( Map<String, dynamic> json ){
    return Example(
      did: json["did"] ?? null,
      sentence: json["sentence"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "did" : did,
      "sentence" : sentence,
    };
  }
}