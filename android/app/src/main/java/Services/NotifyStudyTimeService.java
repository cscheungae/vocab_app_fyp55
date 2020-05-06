package Services;

import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.example.flashVocab.MainActivity;
import com.example.flashVocab.R;

public class NotifyStudyTimeService extends Worker {
    NotifyStudyTimeService(Context context, WorkerParameters params){
        super(context,params);
    }

    @NonNull
    @Override
    public Result doWork() {
        try {
            String date = getInputData().getString("date");
            Log.i("NotifyStudyTimeService", date);

            Intent intent = new Intent(getApplicationContext(), MainActivity.class);
            intent.putExtra("route", "/study");
            intent.setAction(Intent.ACTION_RUN);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0, intent, 0);

            Notification notification = new NotificationCompat.Builder(getApplicationContext(), "12h3k123")
                    .setContentTitle("Time to study")
                    .setContentText("Revise the words you have learnt with FlashVocab!")
                    .setSmallIcon(R.mipmap.flashvocab_ic_launcher)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent)
                    .build();
            NotificationManagerCompat.from(getApplicationContext()).notify(2389283, notification);
            return Result.success();
        }catch(Exception e){
            e.printStackTrace();
            return Result.failure();
        }
    }


}