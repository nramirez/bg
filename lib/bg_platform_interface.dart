import 'package:bg/options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bg_method_channel.dart';

abstract class BgPlatform extends PlatformInterface {
  /// Constructs a BgPlatform.
  BgPlatform() : super(token: _token);

  static final Object _token = Object();

  static BgPlatform _instance = MethodChannelBg();

  /// The default instance of [BgPlatform] to use.
  ///
  /// Defaults to [MethodChannelBg].
  static BgPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BgPlatform] when
  /// they register themselves.
  static set instance(BgPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> changeWallpaper({
    required String url,
    required WallpaperScale scale,
    required String color,
  }) {
    throw UnimplementedError('changeWallpaper() has not been implemented.');
  }
}
