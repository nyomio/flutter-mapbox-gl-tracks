import Flutter
import UIKit
//
//var channel: FlutterMethodChannel = FlutterMethodChannel()
//
///**
//   #Flutter plugin definíciója
//*/
//public class SwiftMapboxNativePlugin: NSObject, FlutterPlugin {
//    
//  public static func register(with registrar: FlutterPluginRegistrar) {
//    let plugin = SwiftMapboxNativePlugin()
//    let native = FlutterMapsFactory(with: registrar)
//    registrar.register(native, withId: "com.inetrack/flutter_maps")
//    channel = FlutterMethodChannel(name: "flutter_maps", binaryMessenger: registrar.messenger())
//    registrar.addMethodCallDelegate(plugin, channel: channel)
//  }
//
///**
//     #NativeMapboxPlugin methodchannel hívások kezelése
//*/
//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    if call.method == "getCoordinateBounds" || call.method == "getCoordinateAndZoom" {
//        fresult = result
//    }
//    else {
//        result(call.method + " success")
//    }
//     let data : [AnyHashable:Any] = ["data": (call.arguments ?? "")]
//     NotificationCenter.default.post(name: Notification.Name(call.method), object: nil, userInfo: data)
//    
//  }
//    
//}
//
///**
//     #NativeMapboxPlugin methodchannel hívások eredménye, ha konkrét adatot vár vissza a Flutter
//*/
var fresult: FlutterResult? = nil
