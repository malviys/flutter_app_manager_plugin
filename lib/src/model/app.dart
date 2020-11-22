import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

/// App represents the model for Application Object
class App {
  /// Name of application
  final String name;

  /// Package of application
  final String package;

  /// Application Icon
  final Uint8List icon;

  /// Application size
  final int size;

  /// Application data directory
  final String dataDir;

  /// Directory where .apk is stored
  final String srcDir;

  /// The first time when app is installed on device
  final int installTime;

  /// Category of app
  final AppCategory category;

  App.fromJson(Map<String, Object> json)
      : assert(json["app_name"] != null),
        assert(json["app_icon"] != null),
        assert(json["package_name"] != null),
        assert(json["app_size"] != null),
        assert(json["data_dir"] != null),
        assert(json["src_dir"] != null),
        assert(json["install_time"] != null),
        assert(json["app_category"] != null),
        name = json["app_name"],
        package = json["package_name"],
        size = json["app_size"],
        dataDir = json["data_dir"],
        srcDir = json["src_dir"],
        installTime = json["install_time"],
        category = _parseCategory(json["app_category"]),
        icon = Base64Decoder().convert(json["app_icon"]);

  // convert size to readable form
  static String parseSize(Object o) {
    if (!(o is num)) return "0 B";

    final size = o as int;
    final bytes = ["B", "KB", "MB", "GB", "TB"];
    final index = ((math.log(size) / math.log(2)) / 10).floor() - 1;

    return "${(size / math.pow(1024, index)).toStringAsFixed(2)} ${bytes[index]}";
  }

  // The platform will return the ordinal for app category and the ordinal are mapped to proper category
  static AppCategory _parseCategory(Object o) {
    AppCategory appCategory;

    if (!(o is num)) return AppCategory.UNDEFINED;

    switch (o) {
      case 0:
        appCategory = AppCategory.GAME;
        break;
      case 1:
        appCategory = AppCategory.AUDIO;
        break;
      case 2:
        appCategory = AppCategory.VIDEO;
        break;
      case 3:
        appCategory = AppCategory.IMAGE;
        break;
      case 4:
        appCategory = AppCategory.SOCIAL;
        break;
      case 5:
        appCategory = AppCategory.NEWS;
        break;
      case 6:
        appCategory = AppCategory.MAP;
        break;
      case 7:
        appCategory = AppCategory.PRODUCTIVITY;
        break;
      default:
        appCategory = AppCategory.UNDEFINED;
    }

    return appCategory;
  }
}

// Category of apps
enum AppCategory {
  GAME, // 0
  AUDIO, // 1
  VIDEO, // 2
  IMAGE, // 3
  SOCIAL, // 4
  NEWS, // 5
  MAP, // 6
  PRODUCTIVITY, // 7
  UNDEFINED // -1
}
