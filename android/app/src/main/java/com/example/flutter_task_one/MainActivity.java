package com.example.flutter_task_one;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.os.StrictMode;

import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {
    static final String TAG = "flutter_task";
    static final String CHANNEL = "com.example.flutter_task_one/service";

    AppService appService;
    boolean serviceConnected = false;
    MethodChannel.Result keepResult = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        if (android.os.Build.VERSION.SDK_INT > 9)
        {
            StrictMode.ThreadPolicy policy = new
                    StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(this::onMethodCall);
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStop() {
        super.onStop();

        if (serviceConnected) {
            unbindService(connection);
            serviceConnected = false;
        }
    }

    private void connectToService() {
        if (!serviceConnected) {
            Intent service = new Intent(this, AppService.class);
            startService(service);
            bindService(service, connection, Context.BIND_AUTO_CREATE);
        } else {
            Log.i(TAG, "Service already connected");
            if (keepResult != null) {
                keepResult.success(null);
                keepResult = null;
            }
        }
    }

    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            AppService.AppServiceBinder binder = (AppService.AppServiceBinder) service;
            appService = binder.getService();
            serviceConnected = true;
            Log.i(TAG, "Service connected");
            if (keepResult != null) {
                keepResult.success(null);
                keepResult = null;
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            serviceConnected = false;
            Log.i(TAG, "Service disconnected");
        }
    };

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        try {
            if (call.method.equals("connect")) {
                connectToService();
                keepResult = result;
            } else if (serviceConnected) {
                if (call.method.equals("getImagesByteArrayData")) {
                    List<byte[]> imagesByteArrayData = appService.getImagesByteArrayData(call.argument("imageURLs"));

                    result.success(imagesByteArrayData);
                } else if (call.method.equals("toggleMediaPlayer")) {
                    appService.toggleMediaPlayer();

                    result.success(null);
                }
            } else {
                result.error(null, "App not connected to service", null);
            }
        } catch (Exception e) {
            result.error(null, e.getMessage(), null);
        }
    }
}