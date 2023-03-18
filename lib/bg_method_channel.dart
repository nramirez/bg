import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bg_platform_interface.dart';

/// An implementation of [BgPlatform] that uses method channels.
class MethodChannelBg extends BgPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bg');

  @override
  Future<String?> changeWallpaper({required String url}) async {
    final version = await methodChannel
        .invokeMethod<String>('changeWallpaper', <String, dynamic>{
      'url': url,
    });
    return version;
  }
}