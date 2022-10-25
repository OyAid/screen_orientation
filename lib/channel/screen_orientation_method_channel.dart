import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:screen_orientation/enum/screen_orientation_enum.dart';
import 'package:screen_orientation/utils/screen_orientation_utils.dart';

import 'screen_orientation_platform_interface.dart';

/// An implementation of [ScreenOrientationPlatform] that uses method channels.
class MethodChannelScreenOrientation extends ScreenOrientationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final basicMessageChannel = const BasicMessageChannel(
    'screen_orientation',
    StandardMessageCodec(),
  );

  ///自定义BasicMessageChannel通道的传递参数
  Map<String, dynamic> _invokeMethod({
    required String name,
    Map<String, dynamic>? parameter,
  }) {
    Map<String, dynamic> method = {"method": name};
    if (parameter != null) {
      method.addAll(parameter);
    }
    return method;
  }

  @override
  Future<bool> init() async {
    Object? initStatus = await basicMessageChannel.send(
      _invokeMethod(name: "init"),
    );
    if (initStatus != null) {
      return initStatus as bool;
    } else {
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    await basicMessageChannel.send(_invokeMethod(name: "dispose"));
  }

  @override
  Future<void> screenChange({
    required Function(ScreenOrient) screenOrient,
    Function(CameraOrient)? cameraOrient,
  }) async {
    basicMessageChannel.setMessageHandler((Object? message) async {
      Object? msg = message;
      if (msg == null) return;
      Map reply = msg as Map;
      String screenValue = reply["screen"];
      String cameraValue = reply["camera"];
      if (cameraOrient != null) {
        cameraOrient(
          ScreenOrientationUtils.cameraTextSwitchEnum(str: cameraValue),
        );
      }
      return screenOrient(
        ScreenOrientationUtils.screenTextSwitchEnum(str: screenValue),
      );
    });
  }
}
