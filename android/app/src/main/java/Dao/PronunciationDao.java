package Dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

import Entities.Pronunciation;

@Dao
public abstract class PronunciationDao {
    @Query("select * from Pronunciation")
    public abstract List<Pronunciation> getAll();

    @Insert
    public abstract long insert(Pronunciation p);

    @Insert
    public abstract List<Long> insertAll(Pronunciation... ps);

    @Delete
    public abstract void delete(Pronunciation... p);

}
