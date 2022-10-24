import 'screen_orientation_platform_interface.dart';

class ScreenOrientation {
  static Future<String?> getPlatformVersion() {
    return ScreenOrientationPlatform.instance.getPlatformVersion();
  }
}
