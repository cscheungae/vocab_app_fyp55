package com.example.flashVocab;

import java.util.HashMap;
import java.util.List;


//*
// The class modelling the response from wordsAPI without specifying arguments.
// The response looks like this:
// {
//    "word": "definition",
//    "results": [
//        {
//            "definition": "a concise explanation of the meaning of a word or phrase or symbol",
//            "partOfSpeech": "noun",
//            "typeOf": [
//                "account",
//                "explanation"
//            ],
//            "hasTypes": [
//                "dictionary definition",
//                "explicit definition",
//                "ostensive definition",
//                "recursive definition",
//                "redefinition",
//                "stipulative definition",
//                "contextual definition"
//            ],
//            "derivation": [
//                "define"
//            ]
//        },
//        {
//            "definition": "clarity of outline",
//            "partOfSpeech": "noun",
//            "typeOf": [
//                "sharpness",
//                "distinctness"
//            ],
//            "derivation": [
//                "define"
//            ],
//            "examples": [
//                "exercise had given his muscles superior definition"
//            ]
//        }
//    ],
//    "syllables": {
//        "count": 4,
//        "list": [
//            "def",
//            "i",
//            "ni",
//            "tion"
//        ]
//    },
//    "pronunciation": {
//        "all": ",dɛfə'nɪʃən"
//    },
//    "frequency": 3.71
//}
//
//
// */
public class ResponseData {
    public String word;
    public List <WordDefinitions> results;
    public HashMap<String,?> syllables;
    public double frequency;//zipf

    public String getWord() {
        return word;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public List<WordDefinitions> getResults() {
        return results;
    }

    public void setResults(List<WordDefinitions> results) {
        this.results = results;
    }

    public HashMap<String, ?> getSyllables() {
        return syllables;
    }

    public void setSyllables(HashMap<String, ?> syllables) {
        this.syllables = syllables;
    }

    public double getFrequency() {
        return frequency;
    }

    public void setFrequency(double frequency) {
        this.frequency = frequency;
    }
    //get a specific word.
    public WordDefinitions getResult(int i) throws ArrayIndexOutOfBoundsException{
        return results.get(i);
    }

    @Override
    public String toString() {
        String definitions = "";
        results.forEach(res->definitions.concat(res.toString()+"\n\n"));
        return "word: "+word+"\n"+definitions;

    }

}


class WordDefinitions{
    private String definition;
    private String partOfSpeech;
    private List<String> typeof;
    private List<String> examples;
    public HashMap<String,?> pronunciation;

    public String getDefinition() {
        return definition;
    }

    public void setDefinition(String definition) {
        this.definition = definition;
    }

    public String getPartOfSpeech() {
        return partOfSpeech;
    }

    public void setPartOfSpeech(String partOfSpeech) {
        this.partOfSpeech = partOfSpeech;
    }

    public List<String> getTypeOf(){
        return typeof;
    }

    public void setTypeof(List<String> typeof) {
        this.typeof = typeof;
    }


    public List<String> getExamples() {
        return examples;
    }

    public void setExamples(List<String> examples) {
        this.examples = examples;
    }

    public HashMap<String,?> getPronunciation(){
        return this.pronunciation;
    }

    public void setPronunciation(HashMap<String, ?> pronunciation) {
        this.pronunciation = pronunciation;
    }

    public String toString() {
        return  "definition: "+definition+"\n"+
                (examples==null?
                "NO EXAMPLES.\n":
                examples.size()+" EXAMPLES.\n");
    }
}