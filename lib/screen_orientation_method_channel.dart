import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_orientation_platform_interface.dart';

/// An implementation of [ScreenOrientationPlatform] that uses method channels.
class MethodChannelScreenOrientation extends ScreenOrientationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_orientation');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
