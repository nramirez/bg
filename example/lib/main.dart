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
          'https://live.staticflickr.com/65535/52438139047_6270dfdaab_o_d.jpg');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Change wallpaper:'),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Image URL',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await _bgPlugin.changeWallpaper(url: controller.text);
                  print(result);
                },
                child: const Text('Change wallpaper'),
              ),
              CachedNetworkImage(imageUrl: controller.text),
            ],
          ),
        ),
      ),
    );
  }
}
