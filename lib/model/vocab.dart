import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

enum Status {
  tracked, learning, matured
}

class Vocab
{
  // Field
  int vid;
  String word;
  String imageUrl;
  int wordFreq;
  int trackFreq;
  Status status;

  // Constructor
  Vocab({ vid, word, imageUrl, wordFreq, trackFreq, status })
  {
    this.vid = vid ?? null;
    this.word = word;
    this.imageUrl = imageUrl ?? "";
    this.wordFreq = wordFreq ?? 0; // TODO:: create a provider to call the api to get the word freq
    this.trackFreq = trackFreq ?? 0;
    this.status = status ?? Status.tracked;
  }

  factory Vocab.fromJson( Map<String, dynamic> json) {
    return new Vocab(
      vid: json["vid"],
      word: json["word"],
      imageUrl: json["imageUrl"],
      wordFreq: json["wordFreq"],
      trackFreq: json["trackFreq"],
      status: Status.values[json["status"]],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "vid": vid,
      "word": word,
      "imageUrl": imageUrl,
      "wordFreq": wordFreq,
      "trackFreq": trackFreq,
      "status": status.index,
    };
  }
}