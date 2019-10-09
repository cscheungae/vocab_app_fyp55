package com.example.vocab_app_fyp55;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;


import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class WordModalActivity extends Activity {
    //UI Component
    private LinearLayout layout;
    private TextView wordTitle;
    private TextView posTitle;
    private TextView posValue;
    private TextView defTitle;
    private TextView defValue;
    private Button backBtn;

    private DatabaseReference mDatabase;
    private String word;

    /*
     * References:
     *
     * Keep API Key in secret: https://richardroseblog.wordpress.com/2016/05/29/hiding-secret-api-keys-from-git/
     * API Result format: https://rapidapi.com/wordsapi/api/wordsapi?endpoint=54b86419e4b058c0230e421c
     *
     */

    // Configuration of the api request link
    private String baseUrl = "https://wordsapiv1.p.rapidapi.com/";
    private String apiKey = BuildConfig.WORDSAPI_KEY;
    private String host = "wordsapiv1.p.rapidapi.com";

    // Initialize a http client
    private final OkHttpClient client = new OkHttpClient();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_word_modal);

        mDatabase = FirebaseDatabase.getInstance().getReference();
        word = getIntent().getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT).toString();

        layout = findViewById(R.id.linearLayout);
        wordTitle = findViewById(R.id.wordTitle);
        posTitle = findViewById(R.id.posTitle);
        posValue = findViewById(R.id.posValue);
        defTitle = findViewById(R.id.defTitle);
        defValue = findViewById(R.id.defValue);
        backBtn = findViewById(R.id.backBtn);

        backBtn.setOnClickListener((View view) -> finish());
    }

    @Override
    protected void onResume() {
        super.onResume();
        // call the service to upload word
        checkVocabAndUpload(word);
    }

    // use set time out to mimic the delay of the call of api
    private void checkVocabAndUpload(String word) {

        // call the worker to check the dictionary and upload the word
        try {
            Integer code = new CheckDictTask().execute(word).get(10000, TimeUnit.MILLISECONDS);

            if (code == RESULT_OK) {
                return ;
            } else {
                Toast.makeText(getApplicationContext(), "Failed uploading. Code: RESULT_CANCELED", Toast.LENGTH_SHORT).show();
                finish();
            }
        } catch ( TimeoutException ex ) {
            Toast.makeText(getApplicationContext(), "Timeout()", Toast.LENGTH_SHORT).show();
            finish();
        } catch ( InterruptedException ex ) {
            Toast.makeText(getApplicationContext(), "Interrupted Exception", Toast.LENGTH_SHORT).show();
            finish();
        } catch ( ExecutionException ex ) {
            Toast.makeText(getApplicationContext(), "Execution Exception", Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    protected void onDestroy() {
        Toast.makeText(getApplicationContext(), "Finished uploading. You can proceed reading.", Toast.LENGTH_SHORT).show();
        super.onDestroy();
    }

    private class CheckDictTask extends AsyncTask<String, Void, Integer> {
        // Do the long-running work in here

        protected Integer doInBackground(String ...word) {
            Request request = new Request.Builder()
                    .url(baseUrl + "words/" + word[0] + "/definitions")
                    .header("X-RapidAPI-Host", host)
                    .addHeader("X-RapidAPI-Key", apiKey)
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

                Data rsp = new Gson().fromJson(response.body().string(), Data.class);

                // update the UI
                wordTitle.setText(rsp.getWord());
                posValue.setText(rsp.getDefinitions().get(0).getPartOfSpeech());
                defValue.setText(rsp.getDefinitions().get(0).getDefinition());
                // make the UI visible
                layout.setVisibility(View.VISIBLE);
                wordTitle.setVisibility(View.VISIBLE);
                posTitle.setVisibility(View.VISIBLE);
                posValue.setVisibility(View.VISIBLE);
                defTitle.setVisibility(View.VISIBLE);
                defValue.setVisibility(View.VISIBLE);
                backBtn.setVisibility(View.VISIBLE);

                Vocabulary vocab = new Vocabulary(word[0], rsp.getDefinitions().get(0).getDefinition());
                mDatabase.child(word[0]).child(word[0]).setValue(vocab);
            } catch (IOException ex) {
                ex.printStackTrace();
                return RESULT_CANCELED;
            }
            return RESULT_OK;
        }
    }
}
