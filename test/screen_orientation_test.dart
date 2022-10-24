import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_orientation/screen_orientation.dart';
import 'package:screen_orientation/screen_orientation_method_channel.dart';
import 'package:screen_orientation/screen_orientation_platform_interface.dart';

class MockScreenOrientationPlatform
    with MockPlatformInterfaceMixin
    implements ScreenOrientationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScreenOrientationPlatform initialPlatform =
      ScreenOrientationPlatform.instance;

  test('$MethodChannelScreenOrientation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenOrientation>());
  });

  test('getPlatformVersion', () async {
    MockScreenOrientationPlatform fakePlatform =
        MockScreenOrientationPlatform();
    ScreenOrientationPlatform.instance = fakePlatform;

    expect(await ScreenOrientation.getPlatformVersion(), '42');
  });
}
