import 'package:aeye/Home.dart';
import 'package:aeye/Theme.dart';
import 'package:flutter/material.dart';
import 'Camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'BoundingBox.dart';
import 'Models.dart';

class LiveCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  LiveCameraScreen(this.cameras);

  @override
  _LiveCameraScreenState createState() => new _LiveCameraScreenState();
}

class _LiveCameraScreenState extends State<LiveCameraScreen> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt");
      } else {
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Live Detection Screen',
            style: TextStyle(
              fontFamily: 'Source Code Pro',
              fontSize: 25,
              color: const Color(0xff707070),
              fontWeight: FontWeight.w300,
            ),
          )),
      body: _model == ""
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Container(
                      height: screen.height / 2 - 42,
                      width: screen.width,
                      child: RaisedButton(
                        color: AppTheme.cardColor,
                        child: const Text(ssd),
                        onPressed: () => onSelect(ssd),
                      )),
                  Container(
                    height: screen.height / 2 - 42,
                    width: screen.width,
                    child: RaisedButton(
                      color: AppTheme.cardColor,
                      child: const Text(yolo),
                      onPressed: () => onSelect(yolo),
                    ),
                  ),
                ]))
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BoundingBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
        child: Icon(Icons.keyboard_backspace),
        backgroundColor: AppTheme.buttonColor,
      ),
    );
  }
}
