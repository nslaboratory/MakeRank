import 'dart:io';
import 'dart:typed_data';

//import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CropSample extends StatefulWidget {
  @override
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CropSample> {
  late Future<File> future;
  late Future<CroppedFile> future2;
  final picker = ImagePicker();
  var pickedFile, data, data2;
//  final _controller = CropController();

  @override
  void initState() {
    super.initState();
    future = Future(
      () async {
//        await Future.delayed(const Duration(seconds: 1));
//        return "hoge";
//        pickedFile = await picker.pickImage(source: ImageSource.gallery);
//        data = await File(pickedFile!.path).readAsBytes();

//        data = await File(
//                (await picker.pickImage(source: ImageSource.gallery))!.path)
//            .readAsBytes();
//        data = File((await picker.pickImage(source: ImageSource.gallery))!.path)
//            .readAsBytes();
        data =
            File((await picker.pickImage(source: ImageSource.gallery))!.path);
        return data;
      },
    );
/*
    future2 = Future(
      () async {
//        data = (await future).readAsBytes();
        data2 = await ImageCropper().cropImage(
          sourcePath: data.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        return data2;
      },
    );
*/
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("none");
          case ConnectionState.waiting:
            print("waiting1");
//            return const Text("waiting");
            return const Text("");
          case ConnectionState.active:
            return const Text("active");
          case ConnectionState.done:
//            return Text(snapshot.data!.path);
//            return Image.memory(snapshot.data!.readAsBytesSync());
            future2 = Future(
              () async {
//        data = (await future).readAsBytes();
                data2 = await ImageCropper().cropImage(
                  sourcePath: snapshot.data!.path,
                  compressFormat: ImageCompressFormat.jpg,
                  compressQuality: 100,
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                      presentStyle: CropperPresentStyle.dialog,
                      boundary: const CroppieBoundary(
                        width: 520,
                        height: 520,
                      ),
                      viewPort: const CroppieViewPort(
                          width: 480, height: 480, type: 'circle'),
                      enableExif: true,
                      enableZoom: true,
                      showZoomer: true,
                    ),
                  ],
                );
                return data2;
              },
            );

            return FutureBuilder<CroppedFile>(
              future: future2,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text("none");
                  case ConnectionState.waiting:
                    print("waiting2");
//                    return const Text("waiting2");
                    return const Text("");
//                    return Image.asset("assets/icon_android.png");
                  case ConnectionState.active:
                    return const Text("active");
                  case ConnectionState.done:
//            return Text(snapshot.data!.path);
                    return Image.memory(
                        File(snapshot.data!.path).readAsBytesSync());
//                    return Image.asset("assets/icon_android.png");
/*                    return Crop(
                        image: snapshot.data!,
                        controller: _controller,
                        onCropped: (image) {
                          // do something with cropped image data
                        });*/
                }
              },
            );
        }
      },
    );
  }
}
