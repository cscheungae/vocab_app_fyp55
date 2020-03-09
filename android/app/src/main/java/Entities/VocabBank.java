package Entities;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import javax.annotation.Nullable;

@Entity(tableName = "Vocab")
public class VocabBank {

    @PrimaryKey(autoGenerate = true)
    public Integer vid;

    @ColumnInfo(name = "wordFreq")
    public  Integer wordFreq;

    @ColumnInfo(name = "trackFreq")
    public Integer trackFreq;

    @ColumnInfo(name = "word")
    public  String word;

    @ColumnInfo(name = "imageUrl")
    public  String imageUrl;

    @ColumnInfo(name = "status")
    public Integer status;

    public VocabBank(String word,@Nullable String imageUrl,Integer wordFreq,Integer trackFreq){
        this.word = word;
        this.wordFreq = wordFreq;
        this.trackFreq=trackFreq;
        if(imageUrl!=null)
            this.imageUrl = imageUrl;
        this.status=0;
    }


}
