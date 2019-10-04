import 'dart:io';
import 'dart:typed_data';

import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Uint8List _resizedImage;
  Uint8List _originalImage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_resizedImage != null) Image.memory(_resizedImage, fit: BoxFit.cover,),
              if (_originalImage != null) Image.memory(_originalImage, fit: BoxFit.cover,),
              RaisedButton(
                onPressed: () {
                  ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
//                    print('start read bytes');
//                    final bytes = file.readAsBytesSync();
//                    print('start decode');
//                    _originalImage = bytes;
//                    final image = img.decodeImage(bytes);
//                    print('image size: ${image.getBytes().length}');
//                    img.Image resizedImage = image;
//                    if (image.height < image.width && image.height > 1000) {
//                      resizedImage = img.copyResize(image, height: 900);
//                      print('resized image size: ${resizedImage
//                          .getBytes()
//                          .length}');
//                    } else if (image.width< image.height && image.width >1080) {
//                      resizedImage = img.copyResize(image, width: 1080);
//                      print('resized image size: ${resizedImage
//                          .getBytes()
//                          .length}');
//                    }
//                    final jpg = img.encodeJpg(resizedImage, quality: 100);
//                    _resizedImage = Uint8List.fromList(jpg);
//                    print('jpeg size: ${_resizedImage.length}');
                    var image = FirebaseRepository.saveImage(file).then((image) {
                      print('$image');
                    });
//                    setState(() {
//                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
