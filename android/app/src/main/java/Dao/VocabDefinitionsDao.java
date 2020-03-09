package Dao;


import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import Entities.VocabDefinitions;

import java.util.List;

@Dao
public abstract class VocabDefinitionsDao {
    @Query("SELECT * from Definition")
    public abstract List<VocabDefinitions> getAll();

    @Insert
    public abstract long insert(VocabDefinitions def);

    @Insert
    public abstract long[] insertAll(VocabDefinitions... defs);

    @Delete
    public abstract void delete(VocabDefinitions... defs);



}
