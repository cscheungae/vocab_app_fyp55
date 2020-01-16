
class VocabDefinition {

  //Field
  int vid;
  int did;
  String partOfSpeech;
  String pronunciation;
  String definition;
  String exampleSentence;


  //Normal Constructor
  VocabDefinition( { vid = -1, int did = -1, partOfSpeech = "",  pronunciation = "",  definition = "", exampleSentence = "" }){
    this.vid = vid;
    this.did = did;
    this.partOfSpeech = partOfSpeech;
    this.pronunciation = pronunciation;
    this.definition = definition;
    this.exampleSentence = exampleSentence;
  }

  //Constructor, From Json to Dart Map Data
  factory VocabDefinition.fromJson( Map<String, dynamic> json ){
    return VocabDefinition(
      vid: json["vid"],
      did: json["did"],
      partOfSpeech: json["pos"] ?? "", 
      pronunciation: json["pronunciation"] ?? "",
      definition: json["definition"] ?? "",
      exampleSentence: json["example"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "vid": vid,
      "did" : did,
      "pos" : partOfSpeech,
      "pronunciation" : pronunciation,
      "definition" : definition,
      "example" : exampleSentence,
    };
  }

}