package com.example.vocab_app_fyp55;

import androidx.room.Database;
import androidx.room.RoomDatabase;

import Dao.VocabDao;
import Dao.VocabDefinitionsDao;
import Entities.VocabBank;
import Entities.VocabDefinitions;

@Database(entities = {VocabBank.class, VocabDefinitions.class}, version = 1, exportSchema = false)
public abstract class VocabDB extends RoomDatabase {
    public abstract VocabDao VocabDao();
    public abstract VocabDefinitionsDao VocabDefinitionsDao();

}


