import 'package:bg/options.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class WallpaperModal extends StatefulWidget {
  const WallpaperModal({
    required this.url,
    required this.onSaved,
    super.key,
  });
  final String url;
  final Function(WallpaperScale, String) onSaved;

  @override
  State<WallpaperModal> createState() => _WallpaperModalState();
}

class _WallpaperModalState extends State<WallpaperModal> {
  WallpaperScale scale = WallpaperScale.fill;
  Color color = Colors.white;

  Widget simulateScreen() {
    switch (scale) {
      case WallpaperScale.fill:
        return Container(
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: NetworkImage(widget.url),
              fit: BoxFit.cover,
            ),
          ),
        );
      case WallpaperScale.fit:
        return Container(
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: NetworkImage(widget.url),
              fit: BoxFit.contain,
            ),
          ),
        );
      case WallpaperScale.stretch:
        return Container(
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: NetworkImage(widget.url),
              fit: BoxFit.fill,
            ),
          ),
        );
      case WallpaperScale.center:
        return Container(
          decoration: BoxDecoration(
            color: color,
          ),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(widget.url),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowColorPicker =
        scale == WallpaperScale.fit || scale == WallpaperScale.center;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<WallpaperScale>(
                  underline: Container(),
                  value: scale,
                  onChanged: (value) {
                    setState(() {
                      scale = value!;
                    });
                  },
                  items: WallpaperScale.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().split('.').last),
                        ),
                      )
                      .toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSaved(
                      scale,
                      color.hex,
                    );
                  },
                  child: const Icon(Icons.save_alt),
                ),
              ],
            ),
          ),
          Flexible(
              child: SizedBox(
            width: 300,
            height: 200,
            child: simulateScreen(),
          )),
          if (shouldShowColorPicker)
            Flexible(
              child: ColorPicker(
                pickersEnabled: const {
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false,
                  ColorPickerType.bw: true,
                  ColorPickerType.wheel: true,
                },
                color: color,
                onColorChanged: (value) {
                  setState(() {
                    color = value;
                  });
                },
              ),
            ),
          // avoid jumping around when toggling visibility for colorpicker
          if (!shouldShowColorPicker)
            Flexible(
              child: Container(),
            )
        ],
      ),
    );
  }
}
