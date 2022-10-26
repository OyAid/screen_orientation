import Flutter
import UIKit
    
public class SwiftScreenOrientationPlugin: NSObject, FlutterPlugin {

    //定义FlutterBasicMessageChannel空通道
    static var _channel:FlutterBasicMessageChannel = FlutterBasicMessageChannel()

    //初始化注册通道
    public static func register(with registrar: FlutterPluginRegistrar) {
        _channel = FlutterBasicMessageChannel(name: "screen_orientation", binaryMessenger: registrar.messenger())
        _channel.setMessageHandler{(call, result) in
            let map = call as? Dictionary<String, Any>
            //判断call的类型
            if let dict = map {
                //获取通道方法名
                let methodName:String = dict["method"] as? String ?? ""
                if (methodName == "init") {
                    self.initMethod(result: result)
                } else if methodName == "dispose"{
                    self.dispose(result: result)
                }

            }
        }
    }
    
    //屏幕方向变换通知初始化
    public static func initMethod(result: FlutterReply) {
        //开启设备方向通知
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //注册手机屏幕方向切换的通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientaionDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        let state:Bool = UIDevice.current.isGeneratingDeviceOrientationNotifications
        result(state)
    }
    
    //屏幕方向变换通知销毁
    public static func dispose(result: FlutterResult) {
        // 结束生成设备旋转方向通知
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        // 移除通知
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        let state:Bool = UIDevice.current.isGeneratingDeviceOrientationNotifications
        result(state)
    }
    
    //屏幕方向变换通知
    //此函数需为static类型， 不然监听回调不了这个方法
    @objc private static func deviceOrientaionDidChange() {
        switch UIDevice.current.orientation {
            case .unknown:
            //未知
            print("未知")
            case .portrait:
            //竖屏, 摄像头在上方
            _channel.sendMessage(["screen":"portrait","camera": "top"])
            case .portraitUpsideDown:
            //颠倒竖屏, 摄像头在下方
            _channel.sendMessage(["screen":"portrait","camera": "bottom"])
            case .landscapeLeft:
            //横屏, 摄像头在左方
            _channel.sendMessage(["screen":"landscape","camera": "left"])
            case .landscapeRight:
            //横屏, 摄像头在右方
            _channel.sendMessage(["screen":"landscape","camera": "right"])
            case .faceUp:
            //手机放平，屏幕朝上
            print("手机放平，屏幕朝上")
            case .faceDown:
            //手机放平，屏幕朝下
            print("手机放平，屏幕朝下")
            default:
            //没有方向
            print("没有方向")
        }
    }
}
