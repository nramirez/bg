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
