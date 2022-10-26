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
        var orientation:UIDeviceOrientation = UIDevice.current.orientation
        if orientation == .portrait {
            _channel.sendMessage(["screen":"portrait","camera": "top"])
        } else if orientation == .portraitUpsideDown {
            _channel.sendMessage(["screen":"portrait","camera": "bottom"])
        } else if orientation == .landscapeLeft {
            _channel.sendMessage(["screen":"landscape","camera": "left"])
        } else if orientation == .landscapeRight {
            _channel.sendMessage(["screen":"landscape","camera": "right"])
        }
    }
}
