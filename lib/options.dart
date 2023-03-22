/// Define a set of options for changing wallpaper.
class WallpaperOptions {
  WallpaperOptions({
    required this.url,
    this.scale = WallpaperScale.auto,
    this.color,
  });
  final WallpaperScale scale;
  final String url;

  /// color
  final String? color;

  Map<String, String> toJson() {
    return {
      'scale': scale.toString().split('.').last,
      'url': url,
      'color': color ?? '#ffffff',
    };
  }
}

/// The style to use when setting the wallpaper.
enum WallpaperScale {
  /// Automatically choose the best style for the wallpaper.
  auto,

  /// Fill the screen with the wallpaper, cropping as necessary.
  fill,

  /// Fit the wallpaper within the screen, adding black bars as necessary.
  fit,

  /// Stretch the wallpaper to fill the screen, ignoring the aspect ratio.
  stretch,

  /// Center the wallpaper on the screen.
  center,
}
