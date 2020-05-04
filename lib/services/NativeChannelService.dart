import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeChannelService {
  //Invoke functions in Android Side for notifying the user at the time sepcified by the string.
  static Future<void> notifyUserToStudy(DateTime time) async {
    MethodChannel channel =
        new MethodChannel("com.example.vocab_app_fyp55/flashVocab");
    await channel.invokeMapMethod(
        "notifyUserToStudy", {"reviseTime": time.toIso8601String()});
  }
}
