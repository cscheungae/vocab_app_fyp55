package Services;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

public class NotifyStudyTimeService extends Worker {
    NotifyStudyTimeService(Context context, WorkerParameters params){
        super(context,params);
    }

    @NonNull
    @Override
    public Result doWork() {
        String date =  getInputData().getString("date");
        Log.i("NotifyStudyTimeService",date);

        Notification notification = new NotificationCompat.Builder(getApplicationContext(),"12h3k123")
                .setContentTitle("Hi")
                .setContentText("Time is: "+ date)
                .setSmallIcon(android.R.drawable.sym_def_app_icon)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setAutoCancel(true)
                .build();
        NotificationManagerCompat.from(getApplicationContext()).notify(2389283,notification);
        return Result.success();
    }


}