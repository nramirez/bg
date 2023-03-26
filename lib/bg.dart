import 'package:bg/options.dart';
import 'package:bg/wallpaper_modal.dart';
import 'package:flutter/material.dart';

import 'bg_platform_interface.dart';

/// Update wallpaper from a given url
/// [url] is the url of the image to use as wallpaper
/// [scale] is the scale of the wallpaper
/// [color] is the color to use if the wallpaper is scaled
class Bg {
  /// Change the wallpaper
  /// [url] is the url of the image to use as wallpaper
  /// [scale] is the scale of the wallpaper
  /// [color] is the color to use if the wallpaper is scaled
  Future<String?> changeWallpaper({
    required String url,
    WallpaperScale scale = WallpaperScale.fill,
    String color = '#ffffff',
  }) {
    return BgPlatform.instance.changeWallpaper(
      url: url,
      scale: scale,
      color: color,
    );
  }

  /// Handy widget to show a modal with wallpaper options
  /// [url] is the url of the image to use as wallpaper
  /// [context] is the context of the widget
  Future<void> showWallpaperOptions({
    required String url,
    required BuildContext context,
  }) {
    return showModalBottomSheet<void>(
      // remove top padding
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return WallpaperModal(
            url: url,
            onSaved: (WallpaperScale scale, String color) {
              changeWallpaper(url: url, scale: scale, color: color);
            });
      },
    );
  }
}
