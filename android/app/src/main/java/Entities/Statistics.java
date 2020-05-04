package Entities;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import androidx.room.TypeConverters;


import org.jetbrains.annotations.NotNull;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

import Converters.TimestampConverter;

@Entity(tableName = "Statistics")
public class Statistics {
    @PrimaryKey
    public Integer sid;

    @ColumnInfo(name="trackingCount")
    @NotNull
    public Integer trackingCount;

    @ColumnInfo(name="learningCount")
    @NotNull
    public Integer learningCount;

    @ColumnInfo(name="maturedCount")
    @NotNull
    public Integer maturedCount;

    @ColumnInfo(name="logDate")
    @NotNull
    public String logDate;

    public Statistics(int trackingCount ,int learningCount, int maturedCount){
            this.trackingCount=trackingCount;
            this.learningCount=learningCount;
            this.maturedCount=maturedCount;
            this.logDate=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(new Date());
    }
    public Statistics(){
        this(1,1,0);
    }
}


