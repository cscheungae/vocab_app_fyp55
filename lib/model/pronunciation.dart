class Pronunciation {
  // Field
  int pid;
  int did; // foreign key to definition
  String ipa;
  String audioUrl;   // TODO:: Issue - might need to change to audiostream in future

  // Normal Constructor
  Pronunciation({this.did, this.ipa, this.audioUrl});

  //Constructor, From Json to Dart Map Data
  factory Pronunciation.fromJson( Map<String, dynamic> json ){
    return Pronunciation(
      did: json["did"] ?? null,
      ipa: json["ipa"] ?? "",
      audioUrl: json["audioUrl"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "did" : did,
      "ipa" : ipa,
      "audioUrl": audioUrl,
    };
  }
}