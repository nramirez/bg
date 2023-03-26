/// The style to use when setting the wallpaper.
enum WallpaperScale {
  /// Fill the screen with the wallpaper, cropping as necessary.
  fill,

  /// Fit the wallpaper within the screen, adding black bars as necessary.
  fit,

  /// Stretch the wallpaper to fill the screen, ignoring the aspect ratio.
  stretch,

  /// Center the wallpaper on the screen.
  center,
}
