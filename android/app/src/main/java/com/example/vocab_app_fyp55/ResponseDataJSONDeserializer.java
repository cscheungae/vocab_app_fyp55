package com.example.vocab_app_fyp55;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonArray;


import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.NoSuchElementException;

public class ResponseDataJSONDeserializer implements JsonDeserializer<ResponseData> {

    private static final JsonDeserializer<ResponseData> deserializer = new ResponseDataJSONDeserializer();

    private ResponseDataJSONDeserializer() {

    }

    static JsonDeserializer<ResponseData> getDeserializer() {
        return deserializer;
    }

    @Override
    public ResponseData deserialize(JsonElement json, Type type, JsonDeserializationContext context) throws JsonParseException {
        try {
            ResponseData results = new ResponseData();

            if(json.getAsJsonObject().get("error")!=null)
                return null;

            results.setWord(json.getAsJsonObject().get("id").getAsString());

            List<WordDefinitions> defs = new ArrayList<>();
            results.setResults(defs);
            JsonArray rsp = json.getAsJsonObject().getAsJsonArray("results");
            rsp.forEach(result -> {

                JsonArray LexicalEntries = result.getAsJsonObject().getAsJsonArray("lexicalEntries");
                if(LexicalEntries!=null) {
                    LexicalEntries.forEach((LexicalEntry) -> {
                        //Part of speech
                        String pos = LexicalEntry.getAsJsonObject().get("lexicalCategory").getAsJsonObject().get("text").getAsString();

                        JsonArray entries = LexicalEntry.getAsJsonObject().getAsJsonArray("entries");
                        if(entries!=null) {
                            entries.forEach(entry -> {
                                WordDefinitions def = new WordDefinitions();
                                def.setPartOfSpeech(pos);



                                JsonArray senses = entry.getAsJsonObject().getAsJsonArray("senses");
                                senses.forEach(sense -> {
                                    def.setDefinition(sense.getAsJsonObject().getAsJsonArray("definitions").get(0).getAsString());
                                    List<String> examples = new ArrayList<String>();
                                    JsonArray rsp_examples = sense.getAsJsonObject().getAsJsonArray("examples");

                                    if(rsp_examples!=null)
                                    rsp_examples.forEach(example -> {
                                        examples.add(example.getAsJsonObject().get("text").getAsString());
                                    });

                                    def.setExamples(examples);
                                });
                                defs.add(def);
                            });
                        }
                    });
                }
            });

            return results;
        } catch (NoSuchElementException ex) {

        } catch(NullPointerException ex){
            ex.printStackTrace();
        }
        return null;
    }
}
