import 'package:bg/options.dart';

import 'bg_platform_interface.dart';

/// Manage device wallpapers
class Bg {
  ///
  Future<String?> changeWallpaper({
    required String url,
    WallpaperScale scale = WallpaperScale.auto,
    String color = '#ffffff',
  }) {
    return BgPlatform.instance.changeWallpaper(
      url: url,
      scale: scale,
      color: color,
    );
  }
}
