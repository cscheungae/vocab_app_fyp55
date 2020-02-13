package Entities;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.PrimaryKey;

@Entity(tableName = "VocabDefinitions", foreignKeys =  @ForeignKey(entity = VocabBank.class,parentColumns="vid",childColumns = "vid"))
public class VocabDefinitions {

    @PrimaryKey
    public Integer did;

    @ColumnInfo(name = "vid")
    public Integer vid;

    @ColumnInfo(name = "pos")
    public  String pos;

    @ColumnInfo(name = "pronunciation")
    public  String pronunciation;

    @ColumnInfo(name = "definition")
    public  String definition;

    @ColumnInfo(name = "example")
    public  String example;

    public VocabDefinitions(int did,int vid,String pos,String definition,String pronunciation,String example){
        this.did = did;
        this.vid = vid;
        this.pos = pos;
        this.definition = definition;
        this.pronunciation = pronunciation;
        this.example = example;
    }
}
