import 'bg_platform_interface.dart';

class Bg {
  Future<String?> changeWallpaper({
    required String url,
  }) {
    return BgPlatform.instance.changeWallpaper(url: url);
  }
}
