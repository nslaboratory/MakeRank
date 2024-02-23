import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class NextPage extends StatelessWidget {
  NextPage(this.names, this.imgs);
  final List<String> names;
  final List<Image?> imgs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grid List",
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("ja", "JP"),
        ],
        home: MyPage(
          title: 'Rankる',
          names: names,
          imgs: imgs,
        ));
  }
}

class MyPage extends StatefulWidget {
  const MyPage(
      {super.key,
      required this.title,
      required this.names,
      required this.imgs});

  final String title;
  final List<String> names;
  final List<Image?> imgs;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final globalKey = GlobalKey();
  Uint8List? bytes;

  Future _saveImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(
      pixelRatio: 3,
    );
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List buffer = byteData!.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(buffer);
    print(result["filePath"]);
    await Share.shareXFiles([
      XFile.fromData(buffer, mimeType: "image/png"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Color(0xFFF2F2F7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: globalKey,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                  shrinkWrap: true,
                  children: [
                    GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          widget.names[0],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("1位"),
                      ),
                      child: Image(
                        image: widget.imgs[0]!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          widget.names[1],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("2位"),
                      ),
                      child: Image(
                        image: widget.imgs[1]!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          widget.names[2],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("3位"),
                      ),
                      child: Image(
                        image: widget.imgs[2]!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          widget.names[3],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("4位"),
                      ),
                      child: Image(
                        image: widget.imgs[3]!.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: FilledButton(
                    style:
                        FilledButton.styleFrom(shape: BeveledRectangleBorder()),
                    child: const Text(
                      "画像を保存 & シェア",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(msg: "保存中...");
                      print(widget.names);
                      print(widget.imgs);
                      _saveImage(globalKey);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
