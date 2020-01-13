package com.example.vocab_app_fyp55;

import android.os.Bundle;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity implements FlutterPlugin {
  private static String CHANNEL = "meme";
  private HashMap<String,String> vocab = new HashMap<>();
  private int backticks = 0;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
      new MethodChannel(getFlutterView(),CHANNEL)
              .setMethodCallHandler((req,res)->{
                  if(req.method.equals("display")){
                      res.success("Hello!");

                  }
                  else if(req.method.equals("getVocab")){
                      backticks++;
                      res.success(backticks);
                  }else{
                      System.out.println("Not implemented");
                      res.notImplemented();
                  }
              });
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding){
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding){
    System.out.println("Detached...\n");
  }
}
