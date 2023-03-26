import 'package:bg/options.dart';
import 'package:flutter/material.dart';
import 'package:bg/bg.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bgPlugin = Bg();

  String demoUrl =
      'https://live.staticflickr.com/65535/51106448871_213c324baf_o_d.jpg';

  WallpaperScale _style = WallpaperScale.stretch;

  // color
  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(demoUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            ListTile(
              leading: DropdownButton<WallpaperScale>(
                underline: Container(),
                value: _style,
                onChanged: (value) {
                  setState(() {
                    _style = value!;
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
              title: TextFormField(
                initialValue: demoUrl,
                onChanged: (value) {
                  setState(() {
                    demoUrl = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Image URL',
                ),
              ),
            ),
            ColorPicker(
              pickersEnabled: const {
                ColorPickerType.both: true,
                // ColorPickerType.primary: true,
                // ColorPickerType.accent: true,
              },
              color: color,
              onColorChanged: (value) {
                setState(() {
                  color = value;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'changeWallpaper',
            onPressed: () async {
              await _bgPlugin.changeWallpaper(
                url: demoUrl,
                scale: _style,
                color: color.hex,
              );
            },
            child: const Icon(Icons.wallpaper),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'showWallpaperOptions',
            onPressed: () async {
              await _bgPlugin.showWallpaperOptions(
                url: demoUrl,
                context: context,
              );
            },
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
