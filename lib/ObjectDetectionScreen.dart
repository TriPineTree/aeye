import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:aeye/Models.dart';

class ObjectScreen extends StatefulWidget {
  ObjectScreen({Key key}) : super(key: key);

  @override
  _ObjectScreenState createState() => new _ObjectScreenState();
}

class _ObjectScreenState extends State<ObjectScreen> {
  File _imageFile;
  String _model = yolo;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;
  List _recognition;

  _openGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    this.setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  predictImage(File image) async {
    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _imageFile = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 5,
      blockSize: 32,
      numBoxesPerBlock: 5,
      asynch: true,
    );

    setState(() {
      _recognition = recognitions;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,
        // defaults to 0.1
        numResultsPerClass: 2,
        // defaults to 5
        asynch: true);

    setState(() {
      _recognition = recognitions;
    });
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
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

  List<Widget> renderBoxes(Size screen) {
    if (_recognition == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color red = Colors.red;

    return _recognition.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: red,
            width: 3,
          )),
          child: Text(
            "${re["detectedClass"]}${(re["confidenceInClass"] * 100).toStringAsFixed(0)}",
            style: TextStyle(
              background: Paint()..color = red,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    this.setState(() {
      _imageFile = image;
    });
    predictImage(image);
  }

  Widget _checkImage() {
    if (_imageFile == null) {
      return Text("No Selected Image");
    } else {
      return Image.file(_imageFile, width: 300, height: 300);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];
    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _imageFile == null
          ? Center(child: Text("No Image Selected"))
          : Image.file(_imageFile),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(child: CircularProgressIndicator()));
    }

    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        if (index == 0)
          _openCamera(context);
        else if (index == 1)
          _openGallery(context);
        else if (index == 2) Navigator.pushNamed(context, '/');
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Object Detection Screen',
          style: TextStyle(
            fontFamily: 'Source Code Pro',
            fontSize: 25,
            color: const Color(0xff707070),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: stackChildren,
        overflow: Overflow.clip,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera , color: Colors.cyan),
            title: Text('Camera'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library, color: Colors.cyan),
            title: Text('Gallery'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back, color: Colors.cyan),
            title: Text('Back'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
