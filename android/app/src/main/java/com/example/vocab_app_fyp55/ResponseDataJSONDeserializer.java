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
            results.setWord(json.getAsJsonObject().get("id").getAsString());


            List<WordDefinitions> defs = new ArrayList<>();
            results.setResults(defs);
            JsonArray rsp = json.getAsJsonObject().getAsJsonArray("results");
            rsp.forEach(result -> {

                JsonArray LexicalEntries = result.getAsJsonObject().getAsJsonArray("lexicalEntries");
                LexicalEntries.forEach((LexicalEntry) -> {
                    HashMap<String, String> hmap = new HashMap<String,String>();
                    JsonObject pronunciation = LexicalEntry.getAsJsonObject().getAsJsonArray("pronunciations").get(0).getAsJsonObject();
                    if(pronunciation!=null) {
                        hmap.put("audioUrl", pronunciation.get("audioFile").getAsString());
                        hmap.put("ipa", pronunciation.get("phoneticSpelling").getAsString());
                    }
                    //Part of speech
                    String pos = LexicalEntry.getAsJsonObject().get("lexicalCategory").getAsJsonObject().get("text").getAsString();

                    JsonArray entries = LexicalEntry.getAsJsonObject().getAsJsonArray("entries");

                    entries.forEach(entry -> {
                        WordDefinitions def = new WordDefinitions();
                        def.setPartOfSpeech(pos);


                        if(hmap!=null)
                            def.setPronunciation(hmap);

                        JsonArray senses = entry.getAsJsonObject().getAsJsonArray("senses");
                        senses.forEach(sense -> {
                            def.setDefinition(sense.getAsJsonObject().getAsJsonArray("definitions").get(0).getAsString());
                            List<String> examples = new ArrayList<String>();
                            sense.getAsJsonObject().getAsJsonArray("examples").forEach(example -> {
                                examples.add(example.getAsJsonObject().get("text").getAsString());
                            });
                            def.setExamples(examples);
                        });
                        defs.add(def);
                    });
                });

            });

            return results;
        } catch (NoSuchElementException ex) {

        }
        return null;
    }
}
