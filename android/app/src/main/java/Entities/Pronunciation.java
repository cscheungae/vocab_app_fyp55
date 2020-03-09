package Entities;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.ForeignKey;
import androidx.room.PrimaryKey;

import javax.annotation.Nullable;

@Entity(tableName = "Pronunciation",foreignKeys = @ForeignKey(entity = VocabDefinitions.class,parentColumns = "did",childColumns = "did",onDelete = ForeignKey.CASCADE))
public class Pronunciation {
    @PrimaryKey(autoGenerate = true)
    public Integer pid;

    @ColumnInfo(name = "did")
    @NonNull
    public Integer did;

    @ColumnInfo(name="ipa")
    public String ipa;

    @ColumnInfo(name="audioUrl")
    public String audioUrl;

    public Pronunciation(@Nullable String ipa,@Nullable String audioUrl){
        this.ipa = ipa;
        this.audioUrl = audioUrl;
    }

    public void ReferenceDefinitions(VocabDefinitions d){
        did = d.did;
    }
}
