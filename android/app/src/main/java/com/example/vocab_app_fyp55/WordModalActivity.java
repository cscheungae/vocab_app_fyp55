package com.example.vocab_app_fyp55;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.room.Room;

import Entities.VocabBank;
import Entities.VocabDefinitions;

import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
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

    private String word;

    private Button addButton;

    /*
     * References:
     *
     * Keep API Key in secret: https://richardroseblog.wordpress.com/2016/05/29/hiding-secret-api-keys-from-git/
     * API Result format: https://rapidapi.com/wordsapi/api/wordsapi?endpoint=54b86419e4b058c0230e421c
     *
     */

    // Configuration of the api request link
    private String baseUrl = "https://wordsapiv1.p.rapidapi.com/";
    private String apiKey = "03c9331e71mshfe2c9a490b60397p1a8fc5jsn9cf06f851149";
    private String host = "wordsapiv1.p.rapidapi.com";

    // Initialize a http client
    private final OkHttpClient client = new OkHttpClient();

    VocabDB database;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_word_modal);

        word = getIntent().getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT).toString();

        layout = findViewById(R.id.linearLayout);
        wordTitle = findViewById(R.id.wordTitle);
        posTitle = findViewById(R.id.posTitle);
        posValue = findViewById(R.id.posValue);
        defTitle = findViewById(R.id.defTitle);
        defValue = findViewById(R.id.defValue);
        backBtn = findViewById(R.id.backBtn);

        addButton = findViewById(R.id.AddButton);

        database = Room.databaseBuilder(getApplicationContext(),VocabDB.class,"FYPVocabDB.db").createFromAsset("FYPVocabDB.db").build();
        createNotification();
        addButton.setOnClickListener((View view)->{
            try {
                AccessSQLite task = new AccessSQLite();

                VocabBank vocab = new VocabBank(1,1,word,"sample image.gif");
                VocabDefinitions def = new VocabDefinitions( posValue.getText().toString(),
                        defValue.getText().toString(),"lul","example generated from the word "+word);
                HashMap<String,Object> vocabInfo = new HashMap<>();
                vocabInfo.put("vocab",vocab);
                vocabInfo.put("defs",def);
                //run background task.
                Integer result = task.execute(vocabInfo).get();


                Intent updateVisitCount = new Intent(getApplicationContext(), MainActivity.class);
                updateVisitCount.setAction(Intent.ACTION_SEND);
                startActivity(updateVisitCount);

                finish();
            }
            catch(ExecutionException e){
                System.out.println("Execution Exception");
            }
            catch(InterruptedException e){
                System.out.println("The thread got interrupted!");
            }
            catch(Exception e){
                e.printStackTrace();
                System.out.println("Exception occurred");
            }
        });
        backBtn.setOnClickListener((View view) -> {
            try {
                finish();
            }
            catch(Exception e){
                e.printStackTrace();
                System.out.println("Exception occurred");
            }

        });
    }

    private void createNotification(){
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "12h3k123")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Hi from Flutter")
                .setContentText("This is a native notification lol")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(false);

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);

        notificationManager.notify(1, builder.build());
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
                return;
            } else {
                Toast.makeText(getApplicationContext(), "Failed uploading. Code: RESULT_CANCELED", Toast.LENGTH_SHORT).show();
                finish();
            }
        } catch (TimeoutException ex) {
            Toast.makeText(getApplicationContext(), "Timeout()", Toast.LENGTH_SHORT).show();
            finish();
        } catch (InterruptedException ex) {
            Toast.makeText(getApplicationContext(), "Interrupted Exception", Toast.LENGTH_SHORT).show();
            finish();
        } catch (ExecutionException ex) {
            Toast.makeText(getApplicationContext(), "Execution Exception", Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    protected void onDestroy() {
        //Toast.makeText(getApplicationContext(), "Finished uploading. You can proceed reading.", Toast.LENGTH_SHORT).show();
        super.onDestroy();
    }

    private class CheckDictTask extends AsyncTask<String, Void, Integer> {
        // Do the long-running work in here

        protected Integer doInBackground(String... word) {
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
                addButton.setVisibility(View.VISIBLE);
                return RESULT_OK;

            } catch (IOException ex) {
                ex.printStackTrace();
                return RESULT_CANCELED;
            }
        }
    }

    private class AccessSQLite extends AsyncTask<HashMap<String,?>,Void,Integer>{


        @Override
        protected Integer doInBackground(HashMap<String,?>... info) {
            try {
                if(info[0].get("vocab").getClass()==VocabBank.class && info[0].get("defs").getClass()==VocabDefinitions.class) {
                    VocabBank vocab = (VocabBank) (info[0].get("vocab"));
                    VocabDefinitions def = (VocabDefinitions) (info[0].get("defs"));
                    database.runInTransaction(() -> {
                        //insertID
                        Long insertedVID =  database.VocabDao().insert(vocab);
                        def.ReferencesVocab(insertedVID.intValue());
                        database.VocabDefinitionsDao().insert(def);

                    });
                    return RESULT_OK;
                }
                else
                    throw new IllegalArgumentException("Please Check if the arguments are correct.");

            }
            catch(Exception e){
                e.printStackTrace();
                System.out.println("\n\n");
                Log.e("DBException","DB access error...");
                return RESULT_CANCELED;
            }finally{
                if(database.isOpen())
                    database.close();
            }
        }
        //where you will update UI after the async task is complete
        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);

        }
    }
}