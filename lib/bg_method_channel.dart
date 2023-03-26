import 'package:bg/options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bg_platform_interface.dart';

/// An implementation of [BgPlatform] that uses method channels.
class MethodChannelBg extends BgPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bg');

  @override
  Future<String?> changeWallpaper({
    required String url,
    required WallpaperScale scale,
    required String color,
  }) async {
    return await methodChannel.invokeMethod<String>('changeWallpaper', {
      'url': url,
      'scale': scale.toString().split('.').last,
      'color': color,
    });
  }
}
