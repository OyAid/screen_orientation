import 'package:screen_orientation/enum/screen_orientation_enum.dart';

class ScreenOrientationUtils {
  ///将原生传递来的文字转为屏幕状态的枚举类
  static ScreenOrient screenTextSwitchEnum({required String str}) {
    ScreenOrient screenOrient = ScreenOrient.portrait;
    if (str == "landscape") {
      screenOrient = ScreenOrient.landscape;
    }
    return screenOrient;
  }

  ///将原生传递来的文字转为摄像头方向的枚举类
  static CameraOrient cameraTextSwitchEnum({required String str}) {
    CameraOrient cameraOrient = CameraOrient.top;
    if (str == "bottom") {
      cameraOrient = CameraOrient.bottom;
    } else if (str == "left") {
      cameraOrient = CameraOrient.left;
    } else if (str == "right") {
      cameraOrient = CameraOrient.right;
    }
    return cameraOrient;
  }
}
