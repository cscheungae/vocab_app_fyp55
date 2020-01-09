
import 'package:vocab_app_fyp55/model/example.dart';
import 'package:vocab_app_fyp55/model/pronunciation.dart';

class Definition {

  //Field
  int vid;
  int did;
  String pos;
  String defineText;


  //Normal Constructor
  Definition( { vid, did, pos,  defineText}){
    this.vid = vid;
    this.did = did;
    this.pos = pos;
    this.defineText = defineText ?? "";
  }

  //Constructor, From Json to Dart Map Data
  factory Definition.fromJson( Map<String, dynamic> json ){
    return Definition(
      vid: json["vid"],
      did: json["did"],
      pos: json["pos"] ?? "",
      defineText: json["defineText"] ?? "",
    );
  }

  //Dart data to Json
  Map<String, dynamic> toJson(){
    return {
      "vid": vid,
      "did" : did,
      "pos" : pos,
      "defineText" : defineText,
    };
  }

}