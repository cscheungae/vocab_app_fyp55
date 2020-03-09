package Entities;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.PrimaryKey;

@Entity(tableName = "Example",foreignKeys = @ForeignKey(entity = VocabDefinitions.class, parentColumns = "did",childColumns = "did",onDelete = ForeignKey.CASCADE))
public class Example {
    @PrimaryKey(autoGenerate = true)
    public Integer eid;

    @ColumnInfo(name="did")
    @NonNull
    public Integer did;

    @ColumnInfo(name="sentence")
    public String sentence;

    public Example(String sentence){
        if(sentence!=null)
            this.sentence = sentence;
        else
            this.sentence = "No examples :(";
    }

    public void ReferenceDefinition(Integer did){
        this.did = did;
    }

}
