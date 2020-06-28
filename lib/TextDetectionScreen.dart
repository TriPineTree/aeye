import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aeye/Theme.dart';
import 'package:mlkit/mlkit.dart';

class TextScreen extends StatefulWidget {
  TextScreen({Key key}) : super(key: key);

  @override
  _TextScreenState createState() => new _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  List<VisionText> _textLabels = <VisionText>[];
  File imageFile;

  _openGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = image;
      analyzeLabels();
    });
  }

  _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
      analyzeLabels();
    });
  }

  Widget _checkImage() {
    if (imageFile == null) {
      return Text("No Image Selected",
          style: TextStyle(
            fontFamily: 'Source Code Pro',
            fontSize: 15,
            color: const Color(0xff707070),
            fontWeight: FontWeight.w300,
          ));
    } else {
      return Image.file(imageFile, width: 300, height: 300);
    }
  }

  void analyzeLabels() async {
    try {
      var currentLabels = await textDetector.detectFromPath(imageFile.path);
      if (this.mounted) {
        setState(() {
          _textLabels = currentLabels;
        });
      }
    } catch (e) {
      print("Text Detection failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
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

    final columns = List<Widget>();
    columns.add(buildImageArea());
    columns.add(buildResultBox(_textLabels));

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Text Detection Screen',
            style: TextStyle(
              fontFamily: 'Source Code Pro',
              fontSize: 25,
              color: const Color(0xff707070),
              fontWeight: FontWeight.w300,
            ),
          )),
      body: SingleChildScrollView(child: Column(children: columns)),
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
            icon: Icon(Icons.arrow_back , color: Colors.cyan),
            title: Text('Back'),
          ),
        ],
        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildImageArea() {
    return new Container(
      child: Center(child: _checkImage()),
      color: Color(0xffBCE4E1),
      height: 300.0,
    );
  }

  Widget buildResultBox(List<VisionText> list) {
    if (list.length == 0) {
      print('List = 0');
      return Card(
        child: ListTile(
          title: Text('No Text Detected'),
        ),
      );
    }
    print('List has items');
    return Row(
      children: <Widget>[
        Expanded(
            child: SizedBox(
                height: 300,
                child: ListView.builder(
                  padding: const EdgeInsets.all(1.0),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return _buildTextBox(list[i].text);
//                    return new Text(list[i].text);
                  },
                )))
      ],
    );
  }

  Widget _buildTextBox(text) {
    print(text); // Testing
    return Card(
        child: ListTile(
      title: Text("$text", style: Theme.of(context).textTheme.bodyText1),
      dense: true,
    ));
  }
}
