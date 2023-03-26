# bg - A plugin for changing your wallpaper

[![pub package](https://img.shields.io/pub/v/bg.svg)](https://pub.dev/packages/bg)

## Platform Support

| MacOS |
| :---: |
|   ✔️   |

## Getting Started

You can create your custom widget and call change wallpaper.
```dart
// import bg
import 'package:bg/bg.dart';

// on change
await Bg().changeWallpaper(
    url: [your-url],
    scale: style, // [WallpaperScale]
    color: color.hex, // defaults to #ffffff
);
```

You can also use `showWallpaperOptions` which shows a [BottomSheetModal](https://api.flutter.dev/flutter/material/showModalBottomSheet.html).

```dart
await Bg().showWallpaperOptions(
    url: imageUrl,
    // BuildContext from parent widget
    context: context,
);

```


## Bottom Sheet Modal Example

- http://g.recordit.co/A6q4cmhHbJ.gif
![http://g.recordit.co/A6q4cmhHbJ.gif](http://g.recordit.co/A6q4cmhHbJ.gif)



## Custom Example

![Demo](https://user-images.githubusercontent.com/1899538/226887038-07bd7818-327a-41df-a62f-ad7220499971.png)


## Docs

- Learn more about plugins: Learn more at [plug-in package](https://flutter.dev/developing-packages/).

- See this vid for a vid demo [Spanish]: https://youtu.be/i15yUD-ktFQ

## Notes

- This package only supports MACOS. There are known limitations in other platforms like IOS https://stackoverflow.com/a/6243685/2161256
- We don't support tile scale, because not all the images play nicely with this setting, and MacOS itself doesn't always show the option


PRs are welcome.


