import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vocab_app_fyp55/services/APIKey.dart';

class FetchImage {
  //Field Members
  List<String> imgURLs;

  /* Prevent Over-Pulling of new photos */
  static int _limit = 0;
  static final int limit = 15;

  //Constructor
  FetchImage(List<String> urls) {
    this.imgURLs = urls;
  }

  factory FetchImage.fromJson(Map<String, dynamic> json) {
    var valueJson = json["value"] ?? [];
    var firstImageJson = valueJson ?? [];
    List<String> urls = [];
    for (int i = 0; i < firstImageJson.length; i++) {
      urls.add((firstImageJson[i])["contentUrl"] ?? "");
    }
    return FetchImage(urls);
  }


  //Request The Image by Bing API
  static Future<List<String>> requestImgURLs(String word) async {
    //Prevent OverRequesting
    _limit++;
    if (_limit > limit) return null;

    //HTTP Request
    final String apiAddress =
        "https://api.cognitive.microsoft.com/bing/v7.0/images/search" + "?q=";
    var response = await http.get(
      apiAddress + word,
      headers: {
        "Ocp-Apim-Subscription-Key": APIKey.BingAPI,
        "license": "ShareCommercially",
      },
    );

    if (response.statusCode == 200) {
      FetchImage fi = FetchImage.fromJson(json.decode(response.body));
      return fi.imgURLs;
    } else {
      return null;
    }
  }

  //Only request one image
  static Future<String> requestImgURL(String word, {index: 0}) async {
    List<String> urls = await requestImgURLs(word) ?? [""];
    return urls[0];
  }
}
