package Dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

import Entities.Statistics;

@Dao
public abstract class StatisticsDao {
    @Query("select * from Statistics")
    public abstract List<Statistics> getAll();

    @Insert
    public abstract long insert(Statistics st);

    @Delete
    public abstract void delete(Statistics st);

    @Delete
    public abstract void deleteAll(Statistics... st);
}
