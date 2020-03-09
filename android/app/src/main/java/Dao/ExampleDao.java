package Dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

import Entities.Example;
import Entities.VocabBank;

@Dao
public abstract class ExampleDao {
    @Query("SELECT * from Example")
    public abstract List<Example> getAll();

    @Insert
    public abstract void insertAll(Example... exs);

    //insert one Vocab entry and return the insert ID.
    @Insert
    public abstract long insert(Example exs);

    @Delete
    public abstract void delete(Example... exs);

}
