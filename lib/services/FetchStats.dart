import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vocab_app_fyp55/model/ResponseFormat/StatResponse.dart';
import 'package:vocab_app_fyp55/provider/providerConstant.dart';
import 'package:vocab_app_fyp55/services/AddressMiddleWare.dart';

import 'dart:convert';

class FetchStats {
  FetchStats._();

  List<StatResponse> _statList = [];
  List<StatResponse> get statList => _statList;

  factory FetchStats.fromJson(response) {
    FetchStats fn = new FetchStats._();
    for (int i = 0; i < response.length; i++) {
      fn._statList.add(new StatResponse.fromJson(response[i]));
    }
    return fn;
  }

  static Future<List<StatResponse>> requestRankStats({String sortByParam}) async {
    try {
      if (!(sortByParam == "learningCount") &&
          !(sortByParam == "trackingCount") &&
          !(sortByParam == "matureCount"))
        throw new Exception("wrong sortByParams");

      Map<String, String> queryParams = {'sortByParam': sortByParam};

      var uri = Uri.http(AddressMiddleWare.domain, '/stat', queryParams);

      var returnedResponse = await http.get(uri);
      if (returnedResponse.statusCode == 200) {
        var response = json.decode(returnedResponse.body);
        FetchStats fn = FetchStats.fromJson(response['data']);
        return fn._statList;
      } else {
        throw new Exception(returnedResponse.statusCode.toString());
      }
    } catch (e) {
      print("Failure in requesting RankStats: " + e.toString());
      return null;
    }
  }


  static Future<bool> pushStats({@required int uid, @required int sid, @required DateTime logDate, @required int learningCount, @required int matureCount, @required int trackingCount}) async {
    try {
      Map<String, String> queryParams = {'uid': uid.toString(), 'sid': sid.toString(), 'logDate': logDate.toIso8601String(), 'learningCount': learningCount.toString(), 'matureCount': matureCount.toString(), 'trackingCount': trackingCount.toString()};

      var uri = Uri.http(AddressMiddleWare.domain, '/stat', queryParams);

      var returnedResponse = await http.post(uri);
      if(returnedResponse.statusCode == 200) {
          return true;
      } else if(returnedResponse.statusCode == 400) {
        var response = json.decode(returnedResponse.body);
        if(response['code'] == "ER_DUP_ENTRY")  {
          print('pushStats: The latest stat has been pushed already.');
          return true;
        } else
            throw new Exception(response['err']);
      } else {
        throw new Exception("errno-" + returnedResponse.statusCode.toString());
      }
    } catch(e) {
      print("Message from pushing Stats to the server: " + e.toString());
      return false;
    }
  }
}
