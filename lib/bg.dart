import 'package:bg/options.dart';

import 'bg_platform_interface.dart';

class Bg {
  Future<String?> changeWallpaper({required WallpaperOptions options}) {
    return BgPlatform.instance.changeWallpaper(options: options);
  }
}
