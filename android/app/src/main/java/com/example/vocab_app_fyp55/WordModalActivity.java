package com.example.vocab_app_fyp55;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Choreographer;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;


import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.room.Room;

import Entities.Example;
import Entities.VocabBank;
import Entities.VocabDefinitions;

import com.facebook.stetho.okhttp3.StethoInterceptor;
import com.google.gson.Gson;

import org.w3c.dom.Text;

import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import static android.os.Build.VERSION_CODES.N;


public class WordModalActivity extends Activity {
    //UI Component
    private LinearLayout wordmodelView;
    private RelativeLayout buttonNav;
    private View divider;
    private Button prevButton,nextButton;
    private TextView nameView;
    private TextView posView;
    private TextView definitionsView;
    private TextView examplesView;
    private Button trackButton,cancelButton;

    //data and metadata
    private int page;
    private String word;
    private WordsAPIResponseData rsp=null;
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
    //private final OkHttpClient client = new OkHttpClient();
    //check http requests.
    private final OkHttpClient client = new OkHttpClient.Builder()
            .addNetworkInterceptor(new StethoInterceptor())
            .build();


    VocabDB database;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.word_model_v2);

        word = getIntent().getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT).toString().trim().toLowerCase();
        Log.d("DDDDD",word);
        LoadView();


        database = Room.databaseBuilder(getApplicationContext(),VocabDB.class,"FYPVocabDB2.db").createFromAsset("FYPVocabDB.db").build();
        createNotification();

        trackButton.setOnClickListener((View view)->{
            try {
                AccessSQLite task = new AccessSQLite();
                VocabBank vocab = new VocabBank(word,null,0,(int) rsp.frequency);
                VocabDefinitions   defs = new VocabDefinitions(posView.getText().toString(),definitionsView.getText().toString());
                Example example = new Example(rsp.getResult(page).getExamples()!=null && !rsp.getResult(page).getExamples().isEmpty()
                        ? rsp.getResult(page).getExamples().get(0)
                        :"No example :(");

                HashMap<String,Object> vocabInfo = new HashMap<>();
                vocabInfo.put("vocab",vocab);
                vocabInfo.put("defs",defs);
                vocabInfo.put("example",example);
                //run background task.
                Integer result = task.execute(vocabInfo).get();


                Intent navToArticles= new Intent(getApplicationContext(), MainActivity.class);
                navToArticles.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                navToArticles.setAction(Intent.ACTION_RUN);
                navToArticles.putExtra("route","/articles");
                startActivity(navToArticles);

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
        cancelButton.setOnClickListener((View view) -> {
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
    //set the contents of the views in the background.To show the view you should use RenderViewWithPageNumber instead.
    private void LoadView(){
        buttonNav = (RelativeLayout) findViewById(R.id.navButtons);
        prevButton = (Button) findViewById(R.id.prevButton);
        nextButton = (Button) findViewById(R.id.nextButton);

        wordmodelView = (LinearLayout) findViewById(R.id.wordModel);
        nameView = (TextView) findViewById(R.id.word);
        divider = (View) findViewById(R.id.divider);
        posView = (TextView) findViewById(R.id.pos);
        definitionsView = (TextView) findViewById(R.id.def);
        examplesView = (TextView) findViewById(R.id.examples);
        trackButton = (Button) findViewById(R.id.trackButton);
        cancelButton = (Button) findViewById(R.id.cancelButton);
    }
    //render the view.Eg,

    private void RenderViewWithPageNumber(int i){
        findViewById(R.id.word_model_v2).setVisibility(View.VISIBLE);
        //word model
        /*
        wordmodelView.setVisibility(View.VISIBLE);
        nameView.setVisibility(View.VISIBLE);
        posView.setVisibility(View.VISIBLE);
        definitionsView.setVisibility(View.VISIBLE);
        examplesView.setVisibility(View.VISIBLE);
        trackButton.setVisibility(View.VISIBLE);
        cancelButton.setVisibility(View.VISIBLE);

        prevButton.setVisibility(View.VISIBLE);
        nextButton.setVisibility(View.VISIBLE);
        */

        //set content
        WordDefinitions model = rsp.getResult(i);

        nameView.setText(word);
        posView.setText(model.getPartOfSpeech());

        if(model.getDefinition()!=null)
            definitionsView.setText(model.getDefinition());
        if(model.getExamples()!=null)
            examplesView.setText(model.getExamples().stream().reduce("",(sub,string)->sub+string+"\n"));

        prevButton.setVisibility(View.VISIBLE);
        nextButton.setVisibility(View.VISIBLE);

        prevButton.setOnClickListener((View view)->{
            try{
                page--;
                RenderViewWithPageNumber(page);
            }catch(Exception e){
                e.printStackTrace();
                System.out.println("Navigating to data which is out of bounds.");
            }
        });

        nextButton.setOnClickListener((View view)->{
            try{
                page++;
                RenderViewWithPageNumber(page);
            }catch(Exception e){
                e.printStackTrace();
                System.out.println("Navigating to data which is out of bounds.");
            }
        });

        if(i==0){
            prevButton.setVisibility(View.INVISIBLE);
        }
        if (i==rsp.getResults().size()-1){
            nextButton.setVisibility(View.INVISIBLE);
        }



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
                    .url(baseUrl + "words/" + word[0] )
                    .header("X-RapidAPI-Host", host)
                    .addHeader("X-RapidAPI-Key", apiKey)
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

                rsp = new Gson().fromJson(response.body().string(),WordsAPIResponseData.class);
                System.out.println(rsp);
                page = 0;
                RenderViewWithPageNumber(page);

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
                    Example example = (Example) (info[0].get("example"));
                    database.runInTransaction(() -> {
                        //insertID
                        Long insertedVID =  database.VocabDao().insert(vocab);
                        def.ReferencesVocab(insertedVID.intValue());
                        Long insertedDID = database.VocabDefinitionsDao().insert(def);
                        example.ReferenceDefinition(insertedDID.intValue());
                        Long insertedEID = database.ExampleDao().insert(example);
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