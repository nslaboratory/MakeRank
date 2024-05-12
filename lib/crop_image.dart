import 'dart:io';
import 'dart:typed_data';

//import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';

class CropSample extends StatefulWidget {
  @override
  _CropSampleState createState() => _CropSampleState();
}

class _CropSampleState extends State<CropSample> {
  late Future<File> future;
  late Future<CroppedFile> future2;
//  late CancelableOperation cancel2;
  final picker = ImagePicker();
  var pickedFile, data, data2;
  var dummyfile, dummyfile2;
//  final _controller = CropController();

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file =
        File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  void initState() {
    super.initState();
    future = Future(
      () async {
        dummyfile = await getImageFileFromAssets("icon_android.png");
//        await Future.delayed(const Duration(seconds: 1));
//        return "hoge";
//        pickedFile = await picker.pickImage(source: ImageSource.gallery);
//        data = await File(pickedFile!.path).readAsBytes();

//        data = await File(
//                (await picker.pickImage(source: ImageSource.gallery))!.path)
//            .readAsBytes();
//        data = File((await picker.pickImage(source: ImageSource.gallery))!.path)
//            .readAsBytes();
        var imgfile = (await picker.pickImage(source: ImageSource.gallery));
//        data =
//            File((await picker.pickImage(source: ImageSource.gallery))!.path);
        if (imgfile == null) {
//          WidgetsBinding.instance.addPostFrameCallback((_) {
//          cancel2.cancel();
//          data = File("assets/icon_android.png");
          data = dummyfile;
//          Navigator.of(context).pop();
          Navigator.pop(context, "");
//          });
        } else {
          data = File(imgfile.path);
        }
        return data;
      },
    );
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
            if (identical(snapshot.data, dummyfile)) {
              print("future cancel");
              return const Text("");
            }
            future2 = Future(
              () async {
//        data = (await future).readAsBytes();
                dummyfile2 = CroppedFile(dummyfile.path);
                data2 = await ImageCropper().cropImage(
                  sourcePath: snapshot.data!.path,
                  compressFormat: ImageCompressFormat.jpg,
//                  aspectRatioPresets: [CropAspectRatioPreset.square],
                  aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                  compressQuality: 100,
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.square,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                  ],
                );
                if (data2 == null) {
                  return dummyfile2;
                } else {
                  return data2;
                }
              },
            );
//            cancel2 = CancelableOperation.fromFuture(future2);
//            if (identical(snapshot.data, dummyfile)) {
//              print("future cancel");
//              cancel2.cancel();
//              return const Text("");
//            }

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
                    if (identical(snapshot.data, dummyfile2)) {
                      print("future cancel2");
                      WidgetsBinding.instance.addPostFrameCallback((_) {
//                        Navigator.of(context).pop();
                        Navigator.pop(context, "");
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context, snapshot.data!.path);
                      });
                    }
//                    return Image.memory(
//                        File(snapshot.data!.path).readAsBytesSync());
                    return const Text("");
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
