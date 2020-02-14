package com.example.vocab_app_fyp55;

import com.facebook.stetho.Stetho;

import io.flutter.app.FlutterApplication;

public class MemeApplication extends FlutterApplication {
    //initialize any android settings here.
    @Override
    public void onCreate() {
            super.onCreate();
        //enable Stetho inspection tools. For more, google Stetho,
        Stetho.initializeWithDefaults(this);

    }
}
