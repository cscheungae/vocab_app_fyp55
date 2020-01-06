package com.example.vocab_app_fyp55;

public class Vocabulary {

    public String entry;
    public String def;

    public Vocabulary() {
        // Default constructor required for calls to DataSnapshot.getValue(User.class)
    }

    public Vocabulary(String entry, String def) {
        this.entry = entry;
        this.def = def;
    }
}