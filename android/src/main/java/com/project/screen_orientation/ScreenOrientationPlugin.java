package com.project.screen_orientation;

import android.content.Context;
import android.hardware.SensorManager;
import android.os.Build;
import android.provider.Settings;
import android.view.OrientationEventListener;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;

/** ScreenOrientationPlugin */
public class ScreenOrientationPlugin implements FlutterPlugin, BasicMessageChannel.MessageHandler {

  private BasicMessageChannel<Object> mMessageChannel;

  /**
   * 屏幕方向监听接口
   */
  private OrientationEventListener mOrientationListener;

  /**
   * 上下文
   */
  private Context context;

  /**
   * 记录屏幕方向改变的次数，避免多次回调给flutter
   */
  private int orientationNum = 0;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    //BasicMessageChannel通道
    mMessageChannel = new BasicMessageChannel<Object>(flutterPluginBinding.getBinaryMessenger(), "screen_orientation", StandardMessageCodec.INSTANCE);
    mMessageChannel.setMessageHandler(this);

    //赋值上下文
    context = flutterPluginBinding.getApplicationContext();
  }

  /**
   * BasicMessageChannel通道的方法入口
   */
  @Override
  public void onMessage(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
    Map<Object, Object> arguments = (Map<Object, Object>) message;
    String method = (String) arguments.get("method");    //方法名标识
    if (method.equals("init")) {
      this.init(message, reply);
    } else if (method.equals("dispose")) {
      this.dispose(message, reply);
    }
  }

  /**
   * 初始化OrientationEventListener
   */
  public void init(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
      mOrientationListener = new OrientationEventListener(context,
              SensorManager.SENSOR_DELAY_NORMAL) {
        @Override
        public void onOrientationChanged(int orientation) {
          //如果当前开启了竖屏锁定，则不回调
          int flag = Settings.System.getInt(context.getContentResolver(),
                  Settings.System.ACCELEROMETER_ROTATION, 1);
          if(flag != 1) {
            return;
          }
          if (orientation == OrientationEventListener.ORIENTATION_UNKNOWN) {
            return;  //手机平放时，检测不到有效的角度
          }
          //可以根据不同角度检测处理，这里只检测四个角度的改变
          if (orientation > 350 || orientation < 10) { //0度
            //摄像头朝上
            if (orientationNum == 0) return;
            mMessageChannel.send(resultMap("portrait", "top"));
            orientationNum = 0;
          } else if (orientation > 80 && orientation < 100) { //90度
            //摄像头朝右
            if (orientationNum == 90) return;
            mMessageChannel.send(resultMap("landscape", "right"));
            orientationNum = 90;
          } else if (orientation > 170 && orientation < 190) { //180度
            //摄像头朝下
            if (orientationNum == 180) return;
            mMessageChannel.send(resultMap("portrait", "bottom"));
            orientationNum = 180;
          } else if (orientation > 260 && orientation < 280) { //270度
            //摄像头朝左
            if (orientationNum == 270) return;
            mMessageChannel.send(resultMap("landscape", "left"));
            orientationNum = 270;
          }
        }
      };
      if (mOrientationListener.canDetectOrientation()) {
        mOrientationListener.enable();
        reply.reply(true);
      } else {
        mOrientationListener.disable();
        reply.reply(false);
      }
    }
  }

  /**
   * 销毁OrientationEventListener监听
   */
  public void dispose(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
    orientationNum = 0; //清空记录的屏幕切换次数
    if (mOrientationListener != null) {
      mOrientationListener.disable();
    }
  }

  /**
   * 自定义监听返回值
   * @param screenValue: 屏幕横竖屏返回值
   * @param cameraValue: 摄像头位置返回值
   * @return
   */
  private Map<String, String> resultMap(String screenValue, String cameraValue) {
    Map<String, String> map = new HashMap<>();
    map.put("screen",screenValue);
    map.put("camera",cameraValue);
    return map;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    mMessageChannel.setMessageHandler(null);
  }

}
