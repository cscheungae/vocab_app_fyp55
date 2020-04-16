package Dao;

import androidx.room.Dao;
import androidx.room.Query;

import com.google.firebase.auth.UserInfo;

import java.util.List;

import Entities.User;

@Dao
public abstract class UserDao {

    @Query("Select * from User")
    public abstract List<User> getUser();
}
