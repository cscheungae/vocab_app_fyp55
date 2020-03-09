package com.example.vocab_app_fyp55;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.room.TypeConverter;
import androidx.room.TypeConverters;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import Converters.TimestampConverter;
import Dao.ExampleDao;
import Dao.PronunciationDao;
import Dao.StatisticsDao;
import Dao.VocabDao;
import Dao.VocabDefinitionsDao;
import Entities.Example;
import Entities.Pronunciation;
import Entities.Statistics;
import Entities.VocabBank;
import Entities.VocabDefinitions;

//the database singleton object
public class VocabDataBase{
    private static VocabDB database=null;
    public static void close(){
        if(database.isOpen())
            database.close();
    }
    public static void open(Context context,String dbName){
        try {
            if (database != null)
                database = Room.databaseBuilder(context, VocabDB.class, dbName).createFromAsset(dbName).build();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static VocabDB getInstance(){
        assert database!=null;
        return database;
    }

}


@Database(entities = {VocabBank.class, VocabDefinitions.class, Example.class, Statistics.class, Pronunciation.class}, version = 1, exportSchema = false)
@TypeConverters({TimestampConverter.class})
abstract class VocabDB extends RoomDatabase {
    public abstract VocabDao VocabDao();
    public abstract VocabDefinitionsDao VocabDefinitionsDao();
    public abstract ExampleDao ExampleDao();
    public abstract PronunciationDao PronunciationDao();
    public abstract StatisticsDao StatisticsDao();

}



