package com.example.vocab_app_fyp55;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.work.Data;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import com.google.api.client.util.DateTime;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.SimpleTimeZone;
import java.util.concurrent.TimeUnit;

import Services.NotifyStudyTimeService;
import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;


public class MainActivity extends FlutterActivity  {
  private static String CHANNEL = "meme";
  private HashMap<String,String> vocab = new HashMap<>();
  private int backticks = 0;



    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    createNotificationChannel();
        new MethodChannel(getFlutterView(), "com.example.vocab_app_fyp55/flashVocab").setMethodCallHandler(
                (call, result) -> {
                    try {
                        if (call.method.equals("notifyUserToStudy")) {
                            String reviseTime = ((HashMap<String, String>) call.arguments).get("reviseTime");
                            Date notifyTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(reviseTime);
                            Log.d("MethodChannel-flashVocab","Time received: "+notifyTime.toString());
                            NotifyUsersToStudy();
                        }
                    }
                    catch(ParseException e){
                        e.printStackTrace();
                    }
                }
        );


  }

    @Override
    protected void onNewIntent(Intent intent) {
        String route = intent.getStringExtra("route");
        if(route!=null)
            this.getFlutterView().pushRoute(route);

    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String description = "No description";
            NotificationChannel channel = new NotificationChannel("12h3k123", "native", NotificationManager.IMPORTANCE_DEFAULT);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void NotifyUsersToStudy(){
        Calendar c = Calendar.getInstance();
        c.add(Calendar.SECOND,30);
        long diff = c.getTime().getTime() - new Date().getTime();


        Data data = new Data.Builder().putString("date",c.toString()).build();
        OneTimeWorkRequest promptStudyRequest = new OneTimeWorkRequest.Builder(NotifyStudyTimeService.class)
                .setInitialDelay(diff, TimeUnit.MILLISECONDS)
                .setInputData(data).build();

        WorkManager.getInstance(getApplicationContext()).enqueue(promptStudyRequest);
    }
}
