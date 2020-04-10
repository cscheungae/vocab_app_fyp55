package com.example.vocab_app_fyp55;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.NotificationCompat;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
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
    //createNotificationChannel();
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
}
