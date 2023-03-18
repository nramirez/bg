import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bg/bg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _bgPlugin = Bg();

  final controller = TextEditingController(
      text:
          'https://cdn.midjourney.com/5dda2e78-6759-4016-bfda-f06de574ecc9/0_0.png');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Page URL'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Image URL',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final result =
                        await _bgPlugin.changeWallpaper(url: controller.text);
                    print(result);
                  },
                  child: const Text('Change wallpaper'),
                ),
              ),
              // wrap with scrollable widget to avoid overflow
              SingleChildScrollView(
                child: CachedNetworkImage(imageUrl: controller.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
