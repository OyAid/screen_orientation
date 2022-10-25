import 'package:screen_orientation/channel/screen_orientation_platform_interface.dart';
import 'package:screen_orientation/enum/screen_orientation_enum.dart';

class ScreenOrientation {
  ///初始化屏幕方向插件
  static Future<bool> init() async {
    return await ScreenOrientationPlatform.instance.init();
  }

  ///销毁屏幕方向插件
  static Future<void> dispose() {
    return ScreenOrientationPlatform.instance.dispose();
  }

  ///screenOrient: 获取屏幕竖屏、横屏方向切换状态
  ///cameraOrient: 获取摄像头上下左右位置的切换状态
  static Future<void> screenChange({
    required Function(ScreenOrient) screenOrient,
    Function(CameraOrient)? cameraOrient,
  }) {
    return ScreenOrientationPlatform.instance.screenChange(
      screenOrient: screenOrient,
      cameraOrient: cameraOrient,
    );
  }
}
