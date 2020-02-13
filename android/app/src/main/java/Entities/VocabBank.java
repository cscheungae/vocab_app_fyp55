package Entities;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import javax.annotation.Nullable;

@Entity(tableName = "VocabBank")
public class VocabBank {

    @PrimaryKey
    public Integer vid;

    @ColumnInfo(name = "zipf")
    public  Integer zipf;

    @ColumnInfo(name = "frequency")
    public  Integer frequency;

    @ColumnInfo(name = "name")
    public  String name;

    @ColumnInfo(name = "image")
    public  String image;

    public VocabBank(Integer vid,Integer zipf,Integer frequency,String name,@Nullable String image){
        this.vid = vid;
        this.zipf = zipf;
        this.frequency = frequency;
        this.name = name;
        if(image!=null)
            this.image = image;
    }

}
