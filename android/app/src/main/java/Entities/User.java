package Entities;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.util.List;

@Entity(tableName = "User")
public class User {
    @PrimaryKey
    public Integer uid;
    @ColumnInfo(name = "name")
    public String name;
    @ColumnInfo(name = "password")
    public String password;
    @ColumnInfo(name = "trackThres")
    @NonNull
    public Integer trackThres;
    @ColumnInfo(name = "wordFreqThres")
    @NonNull
    public Integer wordFreqThres;
    @ColumnInfo(name = "region")
    @NonNull
    public String region;
    @ColumnInfo(name = "genres")
    public String genres;



}

