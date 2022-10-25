import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_orientation/screen_orientation.dart';

class ScreenOrientationPage extends StatefulWidget {
  const ScreenOrientationPage({Key? key}) : super(key: key);

  @override
  State<ScreenOrientationPage> createState() => _ScreenOrientationPageState();
}

class _ScreenOrientationPageState extends State<ScreenOrientationPage> {
  String screenOrientation = '竖屏';

  String cameraOrientation = '上方';

  bool isInit = false;

  initData() async {
    bool state = await ScreenOrientation.init();
    if (state) {
      setState(() {
        isInit = true;
      });
      ScreenOrientation.screenChange(
        screenOrient: (screenOrient) {
          if (screenOrient == ScreenOrient.landscape) {
            screenOrientation = "横屏";
          } else {
            screenOrientation = "竖屏";
          }
          setState(() {});
        },
        cameraOrient: (cameraOrient) {
          if (cameraOrient == CameraOrient.top) {
            cameraOrientation = "上";
          } else if (cameraOrient == CameraOrient.bottom) {
            cameraOrientation = "下";
          } else if (cameraOrient == CameraOrient.left) {
            cameraOrientation = "左";
          } else {
            cameraOrientation = '右';
          }
          setState(() {});
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    initData();
  }

  @override
  void dispose() {
    ScreenOrientation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: isInit
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '屏幕是 $screenOrientation 显示',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '摄像头在 $cameraOrientation 方',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              : errorWidget(),
        ),
      ),
    );
  }

  Widget errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          size: 25,
        ),
        Text("初始化失败")
      ],
    );
  }
}
