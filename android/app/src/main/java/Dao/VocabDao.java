package Dao;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
        import androidx.room.Query;

import Entities.VocabBank;

import java.util.List;

@Dao
public abstract class VocabDao {
    @Query("select * from Vocab")
    public abstract List<VocabBank> getAll();

    @Query("select * from Vocab where word = :name")
    public abstract List<VocabBank> findByName(String name);

    @Insert
    public abstract void insertAll(VocabBank... vocabs);

    //insert one Vocab entry and return the insert ID.
    @Insert
    public abstract long insert(VocabBank vocab);

    @Delete
    public abstract void delete(VocabBank... vocabs);


}
