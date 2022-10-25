import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_orientation/channel/screen_orientation_method_channel.dart';
import 'package:screen_orientation/enum/screen_orientation_enum.dart';

abstract class ScreenOrientationPlatform extends PlatformInterface {
  /// Constructs a ScreenOrientationPlatform.
  ScreenOrientationPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenOrientationPlatform _instance = MethodChannelScreenOrientation();

  /// The default instance of [ScreenOrientationPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenOrientation].
  static ScreenOrientationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenOrientationPlatform] when
  /// they register themselves.
  static set instance(ScreenOrientationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Future<void> screenChange({
    required Function(ScreenOrient) screenOrient,
    Function(CameraOrient)? cameraOrient,
  }) {
    throw UnimplementedError('screenChange() has not been implemented.');
  }
}
