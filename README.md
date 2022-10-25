# screen_orientation
Results the preview

<video
    controls=""
    preload="none"
    poster="https://huatu.98youxi.com/markdown/work/uploads/upload_e13dde205ca09ee646ddcb7c3c93d06a.jpg">
    <source src="" type="video/mp4"></source>
</video>

## Installing

Add screen_orientation to your pubspec.yaml file:

```
screen_orientation:
    git:
      url: git://github.com/OyyAd/screen_orientation.git
      ref: master
```

Import get in files that it will be used:

```
import 'package:screen_orientation/screen_orientation.dart';
```
## Usage
1、To initialize the:

```

  @override
  void initState() {
    super.initState();
    await ScreenOrientation.init();
  }
```
2、Listen for screen status changes:

```
ScreenOrientation.screenChange(
    screenOrient: (ScreenOrient screenOrient) {
      //return ScreenOrient枚举
    },
    cameraOrient: (CameraOrient cameraOrient) {
      //return CameraOrient枚举
    },
)
```

3、dispose screen_orientation:

```
  @override
  void dispose() {
    ScreenOrientation.dispose();
    super.dispose();
  }
```

## example


```
String screenOrientation = '竖屏';

String cameraOrientation = '上方';

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
        child: Column(
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
       ),
        ),
      ),
    );
  }
```

## ⚠️⚠️⚠️ notice ⚠️⚠️⚠️

To use this plugin, you need to turn on the rotation function of the phone

