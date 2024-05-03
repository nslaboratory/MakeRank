import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';

class CropSample extends StatefulWidget {
  @override
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CropSample> {
  late Future<Uint8List> future;
  final picker = ImagePicker();
  var pickedFile, data;
  final _controller = CropController();

  @override
  void initState() {
    super.initState();
    future = Future(
      () async {
//        await Future.delayed(const Duration(seconds: 1));
//        return "hoge";
//        pickedFile = await picker.pickImage(source: ImageSource.gallery);
//        data = await File(pickedFile!.path).readAsBytes();
        data = await File(
                (await picker.pickImage(source: ImageSource.gallery))!.path)
            .readAsBytes();
        return data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("none");
          case ConnectionState.waiting:
            return const Text("waiting");
          case ConnectionState.active:
            return const Text("active");
          case ConnectionState.done:
//            return Text(snapshot.data!.path);
            return Crop(
                image: snapshot.data!,
                controller: _controller,
                onCropped: (image) {
                  // do something with cropped image data
                });
        }
      },
    );
  }
}
