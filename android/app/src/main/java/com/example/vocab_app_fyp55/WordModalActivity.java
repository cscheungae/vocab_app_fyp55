package com.example.vocab_app_fyp55;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;


import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.room.Room;

import Entities.Example;
import Entities.Pronunciation;
import Entities.Statistics;
import Entities.User;
import Entities.VocabBank;
import Entities.VocabDefinitions;

import com.facebook.stetho.okhttp3.StethoInterceptor;
import com.google.android.material.snackbar.Snackbar;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import okhttp3.FormBody;
import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;



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

    private final int RESULT_NOT_AUTHORIZED=8888;

    //data and metadata
    private int page;
    private String word;
    private Long zipf;
    private ResponseData rsp=null;
    private User user;
    /*
     * References:
     *
     * Keep API Key in secret: https://richardroseblog.wordpress.com/2016/05/29/hiding-secret-api-keys-from-git/
     * API Result format: https://rapidapi.com/wordsapi/api/wordsapi?endpoint=54b86419e4b058c0230e421c
     *
     */

    // Configuration of the api request link

    // Initialize a http client
    //private final OkHttpClient client = new OkHttpClient();
    //check http requests.
    private final OkHttpClient client = new OkHttpClient.Builder()
            .addNetworkInterceptor(new StethoInterceptor())
            .build();

    //DB
    private VocabDB database;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        database = Room.databaseBuilder(getApplicationContext(),VocabDB.class,Config.DBName).createFromAsset(Config.DBName).build();

        word = getIntent().getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT).toString().trim().toLowerCase();
        LoadView();


        trackButton.setOnClickListener((View view) -> {
            try {

                VocabBank vocab = new VocabBank(word, null, zipf.intValue(), 1);
                VocabDefinitions defs = new VocabDefinitions(posView.getText().toString(), definitionsView.getText().toString());
                Example example0 = null;
                Example example1 = null;
                Example example2 = null;
                Pronunciation pronunciation1 = null;
                List<String> examples = rsp.getResult(page).getExamples();
                if(!examples.isEmpty()) {
                    example0 = new Example(rsp.getResults().get(page).getExamples().get(0));
                    if(examples.size()>1)
                        example1 = new Example(rsp.getResults().get(page).getExamples().get(1));
                    if(examples.size()>2)
                        example2 = new Example(rsp.getResults().get(page).getExamples().get(2));

                }
                HashMap<String,?> pronunciation = rsp.getResult(page).getPronunciation();
                if(pronunciation!=null) {
                    pronunciation1 = new Pronunciation(pronunciation.get("ipa").toString(), pronunciation.get("audioUrl").toString());
                }

                HashMap<String, Object> vocabInfo = new HashMap<>();
                vocabInfo.put("vocab", vocab);
                vocabInfo.put("defs", defs);
                if(example0!=null)
                    vocabInfo.put("example0", example0);
                if(example1!=null)
                    vocabInfo.put("example1", example1);
                if(example2!=null)
                    vocabInfo.put("example2", example2);
                if(pronunciation1!=null){
                    vocabInfo.put("pronunciation",pronunciation1);
                }
                //run background task.
                Integer result = new AddVocabTask().execute(vocabInfo).get();
                if(result==RESULT_CANCELED){
                    AskForRetry("Something wrong happened.Please retry");
                    return;
                }

                Intent navToArticles = new Intent(getApplicationContext(), MainActivity.class);
                navToArticles.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                navToArticles.setAction(Intent.ACTION_RUN);
                navToArticles.putExtra("route", "/articles");
                startActivity(navToArticles);

                finish();
            } catch (ExecutionException e) {
                System.out.println("Execution Exception");
                
            } catch (InterruptedException e) {
                System.out.println("The thread got interrupted!");
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Exception occurred");
            }
        });
        cancelButton.setOnClickListener((View view) -> {
            try {
                finish();
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Exception occurred");
            }

        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        // call the service to upload word
        checkVocabAndUpload(word);
    }
    //set the contents of the views in the background.To show the view you should use RenderViewWithPageNumber instead.
    private void LoadView(){
        setContentView(R.layout.word_model_v2);
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

    private void AskForLogin(){
        Toast toast = Toast.makeText(getApplicationContext(),"Looks like you have not log in.",Toast.LENGTH_LONG);
        toast.show();
    }

    private void AskForAddingNewWords(){
        Toast toast = Toast.makeText(getApplicationContext(),"Looks like the word is not found on the dictionary,Would you like to add this word?",Toast.LENGTH_SHORT);
        toast.show();
    }

    private void AskForRetry(String message){
        Toast toast = Toast.makeText(getApplicationContext(),message,Toast.LENGTH_LONG);
        toast.show();
    }

    //render the view.Eg,
    private void RenderViewWithPageNumber(int i) {
        findViewById(R.id.word_model_v2).setVisibility(View.VISIBLE);

        //set content
        WordDefinitions model = rsp.getResult(i);

        nameView.setText(word);
        posView.setText(model.getPartOfSpeech());

        if (model.getDefinition() != null)
            definitionsView.setText(model.getDefinition());
        if (model.getExamples() != null)
            examplesView.setText(model.getExamples().stream().reduce("", (sub, string) -> sub + string + "\n"));

        prevButton.setVisibility(View.VISIBLE);
        nextButton.setVisibility(View.VISIBLE);

        prevButton.setOnClickListener((View view) -> {
            try {
                page--;
                RenderViewWithPageNumber(page);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Navigating to data which is out of bounds.");
            }
        });

        nextButton.setOnClickListener((View view) -> {
            try {
                page++;
                RenderViewWithPageNumber(page);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Navigating to data which is out of bounds.");
            }
        });

        if (i == 0) {
            prevButton.setVisibility(View.INVISIBLE);
        }
        if (i == rsp.getResults().size() - 1) {
            nextButton.setVisibility(View.INVISIBLE);
        }


    }

    // use set time out to mimic the delay of the call of api
    private void checkVocabAndUpload(String word) {

        // call the worker to check the dictionary and upload the word
        try {
            Integer code = new CheckDictTask().execute(word).get(10000, TimeUnit.MILLISECONDS);
            if (code == RESULT_OK) {
                Integer getVocabWordFrequencyResult = new GetVocabFrequencyTask().execute(word).get(10000, TimeUnit.MILLISECONDS);
                if(getVocabWordFrequencyResult==RESULT_NOT_AUTHORIZED){
                    AskForLogin();
                }
                page = 0;
                RenderViewWithPageNumber(page);

            }
            else if (code==RESULT_NOT_AUTHORIZED){
                AskForLogin();
                finish();
            }
            else {
                AskForAddingNewWords();
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
        super.onDestroy();
        if(database.isOpen())
            database.close();
    }
    //Build the request body and call it to get the result of the word we are interested.
    /*
    returns: RESULT_NOT_AUTHORIZED if the user has not logged in yet.
             RESULT_CANCELLED if the word is not recognized by the service provider.
             RESULT_SUCCESS if found.
    */
    private class CheckDictTask extends AsyncTask<String, Void, Integer> {


        protected Integer doInBackground(String... word) {
            List<User> userList = database.UserDao().getUser();
            if(userList.isEmpty())
                return RESULT_NOT_AUTHORIZED;
            user = database.UserDao().getUser().get(0);

            RequestBody body = new FormBody.Builder()
                    .add("uid",user.uid.toString())
                    .add("password",user.password)
                    .build();

            HttpUrl.Builder url = HttpUrl.parse(Config.serverIP+"/ext/api/vocab").newBuilder();
            if(url==null){ //server is not open or the port is dead
                return RESULT_CANCELED;
            }
            url.addQueryParameter("word",word[0])
                .addQueryParameter("region",user.region);


            Request request = new Request.Builder()
                    .url(url.build())
                    .post(body)
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);
                //WIP: change the implementation of response data
                ResponseDataJSONDeserializer deserializer = (ResponseDataJSONDeserializer) ResponseDataJSONDeserializer.getDeserializer();
                Gson gson = new GsonBuilder().registerTypeAdapter(ResponseData.class,deserializer).create();

                rsp = gson.fromJson(response.body().string(),ResponseData.class);
                return RESULT_OK;

            } catch (IOException ex) {
                ex.printStackTrace();
                return RESULT_CANCELED;
            }
        }
    }

    private class GetVocabFrequencyTask extends AsyncTask<String, Void, Integer>{
        @Override
        protected Integer doInBackground(String... words){
            List<User> user = database.UserDao().getUser();
            if(user.isEmpty())
                return RESULT_NOT_AUTHORIZED;

            HttpUrl.Builder url = HttpUrl.parse(Config.serverIP+"/ext/api/wordfreq").newBuilder();
            url.addQueryParameter("word",words[0]);
            Request request =  new Request.Builder()
                                .url(url.build())
                                .get()
                                .build();

            try(Response response = client.newCall(request).execute()){
                if(!response.isSuccessful()) throw new IOException("Request failure "+response);
                JsonObject wordFrequency = new JsonParser().parse(response.body().string()).getAsJsonObject();
                zipf = wordFrequency.get("frequency").getAsJsonObject().get("zipf").getAsLong();

                return RESULT_OK;
            }
            catch(IOException e){
                e.printStackTrace();
                return RESULT_CANCELED;
            }
            catch(Exception e) {
                return RESULT_CANCELED;
            }
        }
    }

    private class AddVocabTask extends AsyncTask<HashMap<String,?>,Void,Integer>{


        @Override
        protected Integer doInBackground(HashMap<String,?>... info) {
            try {
                if(info[0].get("vocab").getClass()==VocabBank.class && info[0].get("defs").getClass()==VocabDefinitions.class) {
                    VocabBank vocab = (VocabBank) (info[0].get("vocab"));
                    VocabDefinitions def = (VocabDefinitions) (info[0].get("defs"));
                    Example example0 = (Example) (info[0].get("example0"));
                    Example example1 = (Example) (info[0].get("example1"));
                    Example example2 = (Example) (info[0].get("example2"));
                    Pronunciation pronunciation = (Pronunciation) (info[0].get("pronunciation"));

                    database.runInTransaction(() -> {
                        List<VocabBank> existingVocab = database.VocabDao().findByName(vocab.word);
                        //insertID
                        Long insertedVID =  existingVocab.isEmpty()
                                ?database.VocabDao().insert(vocab)
                                :existingVocab.get(0).vid;
                        def.ReferencesVocab(insertedVID.intValue());
                        Long insertedDID = database.VocabDefinitionsDao().insert(def);

                        if(pronunciation!=null){
                            pronunciation.ReferenceDefinitions(insertedDID.intValue());
                            Long insertedPID = database.PronunciationDao().insert(pronunciation);
                        }

                        if(example0!=null){
                            example0.ReferenceDefinition(insertedDID.intValue());
                            Long insertedEID0 = database.ExampleDao().insert(example0);
                        }
                        if(example1!=null){
                            example1.ReferenceDefinition(insertedDID.intValue());
                            Long insertedEID1 = database.ExampleDao().insert(example1);
                        }
                        if(example2!=null){
                            example2.ReferenceDefinition(insertedDID.intValue());
                            Long insertedEID2 = database.ExampleDao().insert(example2);
                        }

                        //change user statistics


                    });
                    return RESULT_OK;
                }
                else
                    throw new IllegalArgumentException("Please Check if the arguments are correct.");

            }
            catch(IllegalArgumentException e){
                e.printStackTrace();
                return RESULT_CANCELED;
            }
            catch(Exception e){
                e.printStackTrace();
                System.out.println("\n\n");
                Log.e("DBException","DB access error...");
                return RESULT_CANCELED;
            }
        }
        //where you will update UI after the async task is complete
        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);

        }
    }
}