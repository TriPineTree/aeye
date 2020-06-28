import 'package:aeye/Main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Main.dart';
import 'package:camera/camera.dart';
import 'ObjectDetectionScreen.dart';
import 'LiveCameraScreen.dart';
import 'TextDetectionScreen.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  MyHomePage(this.cameras);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors:[
                Color(0xff2EE8D7),
                Color(0xffBAF1EB),
              ]
              ),
            ),
            child:
            Transform.translate(
              offset: Offset(0.0,50.0),
            child: Text(
              'aeye',
              style: TextStyle(
                fontFamily: 'Source Code Pro',
                fontSize: 30,
                color: const Color(0xff707070),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
          ),
            )
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                      child: new GestureDetector(
                        child: Container(
                          child: const Icon(Icons.text_fields,
                              size: 40.0, color: Colors.black),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => TextScreen());
                          Navigator.push(context, route);
//                          pageBuilder: TextScreen();
                        },
                      )),
                  const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 5,
                    indent: 10,
                    endIndent: 0,
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            border:
                            Border.all(width: 1.0, color: const Color(0xff707070)),
                          ),
                          child: Text(
                              "Text recognition: This feature extracts text"
                              "from the image source")))
                ],
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            border:
                            Border.all(width: 1.0, color: const Color(0xff707070)),
                          ),
                          child: Text(
                              "Object recognition: This feature extracts object"
                              "from the image source"))),
                  const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 5,
                    indent: 10,
                    endIndent: 0,
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                      child: new GestureDetector(
                        child: Container(
                          child: const Icon(Icons.local_pizza,
                              size: 40.0, color: Colors.black),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => ObjectScreen());
                          Navigator.push(context, route);
                        },
                      ))
                ],
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border:
                        Border.all(width: 1.0, color: const Color(0xff707070)),
                      ),
                      child: new GestureDetector(
                        child: Container(
                          child: const Icon(Icons.camera_enhance,
                              size: 40.0, color: Colors.black),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => LiveCameraScreen(cameras));
                          Navigator.push(context, route);
                        },
                      )),
                  const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 5,
                    indent: 10,
                    endIndent: 0,
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            border:
                            Border.all(width: 1.0, color: const Color(0xff707070)),
                          ),
                          child: Text(
                              "Live Object Recognition: This feature detects "
                              "objects using TensorFlow Lite")))
                ],
              ))
        ],
      ),
    );
  }
}
