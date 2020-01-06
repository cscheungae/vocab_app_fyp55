package com.example.vocab_app_fyp55;

import java.util.List;

public class Data {

    static class Def {
        private String definition;
        private String partOfSpeech;

        public String getDefinition() {
            return definition;
        }

        public String getPartOfSpeech() {
            return partOfSpeech;
        }

        public void setDefinition(String definition) {
            this.definition = definition;
        }

        public void setPartOfSpeech(String pos) {
            this.partOfSpeech = pos;
        }

        public String toString() {
            return String.format("definition: %s, pos: %s", definition, partOfSpeech);
        }
    }

    private String word;
    private List<Def> definitions;

    public String getWord() {
        return word;
    }

    public List<Def> getDefinitions() {
        return definitions;
    }

    public void setWord(String word) {
        this.word = word;
    }

    public void setDefinitions(List<Def> definitions) {
        this.definitions = definitions;
    }

    public String toString() {
        return String.format("word: %s, %s", word, definitions.toString());
    }
}