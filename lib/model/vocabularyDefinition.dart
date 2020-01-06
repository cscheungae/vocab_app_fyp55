
class VocabDefinition {

  //Field
  int vid;
  int definitionID;
  String partOfSpeech;
  String pronunciation;
  String definition;
  String exampleSentence;


  //Normal Constructor
  VocabDefinition( {int vid=-1, int definitionID = -1, partOfSpeech = "",  pronunciation = "",  definition = "", exampleSentence = "" }){
    this.vid = vid;
    this.definitionID = definitionID;
    this.partOfSpeech = partOfSpeech;
    this.pronunciation = pronunciation;
    this.definition = definition;
    this.exampleSentence = exampleSentence;
  }

  //Constructor, From Json to Dart Map Data
  factory VocabDefinition.fromJson( Map<String, dynamic> json ){
    return VocabDefinition(
      vid: json["vid"],
      definitionID: json["did"],
      partOfSpeech: json["pos"] ?? "", 
      pronunciation: json["pronunciation"] ?? "",
      definition: json["definition"] ?? "",
      exampleSentence: json["example"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "vid" : vid,
      "did" : definitionID,
      "pos" : partOfSpeech,
      "pronunciation" : pronunciation,
      "definition" : definition,
      "example" : exampleSentence,
    };
  }

}