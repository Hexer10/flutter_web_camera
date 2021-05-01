import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'camera.dart';

void main() {
  ui.platformViewRegistry.registerViewFactory(
      'video-view',
          (int viewId) => video);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? photoBytes;
  var access = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Web Camera'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    print('Request!');
                    final success = await requestCamera();
                    if (!success) {
                      print('Request failed!');
                      return;
                    }
                    print('Done!');
                    setState(() {
                      access = true;
                    });
                  },
                  child: Text('Press to access camera')),
              ElevatedButton(
                  onPressed: () async {
                    if (!access) {
                      return;
                    }
                    final bytes = takePic();
                    setState(() {
                      photoBytes = bytes;
                    });
                  },
                  child: Text('Take still photo')),
              if (access)
                Container(
                    width: video.videoWidth.toDouble(),
                    height: video.videoHeight.toDouble(),
                    child: HtmlElementView(viewType: 'video-view')),
              if (photoBytes != null) Image.memory(photoBytes!),
            ]),
          ),
        ));
  }
}