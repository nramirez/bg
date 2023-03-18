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
  String demoUrl =
      'https://live.staticflickr.com/65535/51106448871_213c324baf_o_d.jpg';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo - Paste your image url'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _bgPlugin.changeWallpaper(url: demoUrl);
                  },
                  child: const Text('Change wallpaper'),
                ),
              ),
              SingleChildScrollView(
                child: Image.network(
                  demoUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
