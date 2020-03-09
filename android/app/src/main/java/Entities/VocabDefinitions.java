package Entities;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.PrimaryKey;

@Entity(tableName = "Definition", foreignKeys =  @ForeignKey(entity = VocabBank.class,parentColumns="vid",childColumns = "vid",onDelete = ForeignKey.CASCADE))
public class VocabDefinitions {

    @PrimaryKey(autoGenerate = true)
    public Integer did;

    @ColumnInfo(name = "vid")
    @NonNull
    public Integer vid;

    @ColumnInfo(name = "pos")
    public  String pos;

    @ColumnInfo(name = "defineText")
    public  String definition;



    public VocabDefinitions(String pos,String definition){
        this.pos = pos;
        this.definition = definition;
    }
    public void ReferencesVocab(VocabBank vocab){
        this.vid = vocab.vid;
    }

    public void ReferencesVocab(int vid){
        this.vid = vid;
    }
}
