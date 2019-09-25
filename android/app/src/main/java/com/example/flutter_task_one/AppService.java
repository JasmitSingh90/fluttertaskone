package com.example.flutter_task_one;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;
import android.media.MediaPlayer;
import android.provider.Settings;

import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import java.io.InputStream;

public class AppService extends Service {
    // Creating a mediaplayer object
    private MediaPlayer player;
     
    private final IBinder binder = new AppServiceBinder();
    private final String TAG = "flutter_task/service";

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (player == null) { //Null check
            // Getting systems default ringtone
            player = MediaPlayer.create(this,
                    Settings.System.DEFAULT_RINGTONE_URI);

            // Make the ringtone continuously playing
            player.setLooping(true);
        }

        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy: ");
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    public class AppServiceBinder extends Binder {
        AppService getService() {
            return  AppService.this;
        }
    }

    // Method to toggle media player play mode
    public void toggleMediaPlayer() throws Exception {
        if (player != null) {
            if (!player.isPlaying()) {
                // Start the player
                player.start();
            } else {
                // Stop the player
                player.pause();
            }
        }
    }

    // Method to get Images byte array data
    public List<byte[]> getImagesByteArrayData(List<String> imageUrls) {
        
        List<byte[]> imageByteArrayListData = new ArrayList<>();
        try {
            for (String imageUrl : imageUrls) {
                imageByteArrayListData.add(getByteArrayData(imageUrl));
            }
        } catch(Exception ex) {
            Log.i(TAG, "Error getting images");
        }

        return imageByteArrayListData;
    }

    // Method to get single image byte array data
    public byte[] getByteArrayData(String urlText) throws Exception {
        URL url = new URL(urlText);
        ByteArrayOutputStream output = new ByteArrayOutputStream();

        try (InputStream inputStream = url.openStream()) {
            int n = 0;
            byte [] buffer = new byte[ 1024 ];
            while (-1 != (n = inputStream.read(buffer))) {
                output.write(buffer, 0, n);
            }
            output.close();
        }

        return output.toByteArray();
    }
}

