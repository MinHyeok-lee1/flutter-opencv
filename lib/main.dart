// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() => runApp(WebcamApp());

class WebcamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: WebcamPage(),
  );
}

class WebcamPage extends StatefulWidget {
  @override
  _WebcamPageState createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  // Webcam widget to insert into the tree
  late Widget _webcamWidget;
  bool flag = false;
  // VideoElement
  late VideoElement _webcamVideoElement;

  @override
  void initState() {
    super.initState();

    // Create an video element which will be provided with stream source
    _webcamVideoElement = VideoElement();

    // Register an webcam
    ui.platformViewRegistry.registerViewFactory('webcamVideoElement', (int viewId) => _webcamVideoElement);

    // Create video widget
    _webcamWidget = HtmlElementView(key: UniqueKey(), viewType: 'webcamVideoElement');

    // Access the webcam stream
    window.navigator.getUserMedia(video: true).then((MediaStream stream) {
      _webcamVideoElement.srcObject = stream;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Webcam MediaStream:',
            style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
          ),
          Container(width: 750, height: 750, child: _webcamWidget),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => (flag = !flag) ? _webcamVideoElement.play() : _webcamVideoElement.pause(),
      tooltip: 'Start stream, stop stream',
      child: Icon(Icons.camera_alt),
    ),
  );
}
