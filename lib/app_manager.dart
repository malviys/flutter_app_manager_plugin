import 'dart:async';

import 'package:flutter/services.dart';
import 'package:app_manager/src/model/app.dart';

class AppManager {
  static const MethodChannel _channel = const MethodChannel('app_manager');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<App>> getDeviceApps({bool includeSystemApps = false}) async {
    final apps = <App>[];

    try {
      final apps =
          await _channel.invokeMethod("getDeviceApps", <String, Object>{"includeSystemApps": includeSystemApps});
      if (apps is List) {
        for (final app in apps) {
          if (app is Map) {
            try {
              apps.add(App.fromJson(app));
            } on AssertionError catch (e) {
              print(e);
            }
          }
        }
      }
    } on PlatformException catch (e) {
      print("Platform error ${e.message}");
    }

    return apps;
  }
}
