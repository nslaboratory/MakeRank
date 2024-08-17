import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:make_rank/settings.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:make_rank/main.dart';

class NextPage extends StatefulWidget {
  NextPage(this.names, this.imgs, this.imgflgs);

  final List<String> names;
  final List<Image?> imgs;
  final List<int> imgflgs;

  @override
  State<NextPage> createState() => _MyPageState();
}

class _MyPageState extends State<NextPage> {
  final globalKey = GlobalKey();
  Uint8List? bytes;
  bool isIOS = Platform.isIOS;

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

/*
  Widget platformStack(bool isIOS) {
    if (isIOS) {
      print(isIOS);
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 3.0,
        mainAxisSpacing: 3.0,
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        children: [
          GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(
                widget.names[0],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("4位"),
            ),
            child: Image(
              image: widget.imgs[3]!.image,
              fit: BoxFit.cover,
            ),
          )
        ],
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          GridView.count(
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
          // Positioned(
          //   bottom: 5,
          //   right: 10,
          //   child: Text("generated by Rankる", style: TextStyle(color: Colors.white),)
          // )
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Padding(
          //     padding: const EdgeInsets.all(2.0),
          //     child: Text("generated by Rankる",
          //         style: TextStyle(color: Colors.white)),
          //   ),
          // )
        ],
      );
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rankる'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ).then((value) {
                setState(() {
                  rank1Txt = visiblerank ? "1位" : "";
                  rank2Txt = visiblerank ? "2位" : "";
                  rank3Txt = visiblerank ? "3位" : "";
                  rank4Txt = visiblerank ? "4位" : "";
                  rank5Txt = visiblerank ? "5位" : "";
                  rank6Txt = visiblerank ? "6位" : "";
                  rank7Txt = visiblerank ? "7位" : "";
                  rank8Txt = visiblerank ? "8位" : "";
                  rank9Txt = visiblerank ? "9位" : "";
                  print(rank1Txt);
                  if (visibletext == false) {
                    for (int i = 0; i < textFieldList.length; i++) {
                      textFieldList[i] = "";
                    }
                    controller0.clear();
                    controller1.clear();
                    controller2.clear();
                    controller3.clear();
                    controller4.clear();
                    controller5.clear();
                    controller6.clear();
                    controller7.clear();
                    controller8.clear();
                  }
                });
              });
            },
          )
        ],
      ),
      backgroundColor: Color(0xFFF2F2F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: globalKey,
              //child: platformStack(isIOS),
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  GridView.count(
                      padding: EdgeInsets.all(0.0),
                      crossAxisCount: (gridSize == GridSize.grid2x2) ? 2 : 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      shrinkWrap: true,
                      children: (gridSize == GridSize.grid2x2)
                          ? [
                              GridTile(
                                footer: (widget.imgflgs[0] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: Text(
                                          widget.names[0],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: (visiblerank)
                                            ? Text("1位")
                                            : Text(""),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[0] == 1)
                                      ? widget.imgs[0]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[1] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: Text(
                                          widget.names[1],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: (visiblerank)
                                            ? Text("2位")
                                            : Text(""),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[1] == 1)
                                      ? widget.imgs[1]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[2] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: Text(
                                          widget.names[2],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: (visiblerank)
                                            ? Text("3位")
                                            : Text(""),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[2] == 1)
                                      ? widget.imgs[2]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[3] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : GridTileBar(
                                        backgroundColor: Colors.black45,
                                        title: Text(
                                          widget.names[3],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: (visiblerank)
                                            ? Text("4位")
                                            : Text(""),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[3] == 1)
                                      ? widget.imgs[3]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ]
                          : [
                              GridTile(
                                footer: (widget.imgflgs[0] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[0],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("1位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[0] == 1)
                                      ? widget.imgs[0]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[1] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[1],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("2位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[1] == 1)
                                      ? widget.imgs[1]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[2] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[2],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("3位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[2] == 1)
                                      ? widget.imgs[2]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[3] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[3],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("4位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[3] == 1)
                                      ? widget.imgs[3]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[4] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[4],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("5位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[4] == 1)
                                      ? widget.imgs[4]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[5] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[5],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("6位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[5] == 1)
                                      ? widget.imgs[5]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[6] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[6],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("7位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[6] == 1)
                                      ? widget.imgs[6]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[7] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[7],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("8位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[7] == 1)
                                      ? widget.imgs[7]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GridTile(
                                footer: (widget.imgflgs[8] == 0 ||
                                        (!visiblerank & !visibletext))
                                    ? null
                                    : Container(
                                        height: 50,
                                        child: GridTileBar(
                                          backgroundColor: Colors.black45,
                                          title: Text(
                                            widget.names[8],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: (visiblerank)
                                              ? Text("9位")
                                              : Text(""),
                                        ),
                                      ),
                                child: Image(
                                  image: (widget.imgflgs[8] == 1)
                                      ? widget.imgs[8]!.image
                                      : Image.asset("assets/null.png").image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ]),
                  // Positioned(
                  //   bottom: 5,
                  //   right: 10,
                  //   child: Text("generated by Rankる", style: TextStyle(color: Colors.white),)
                  // )
/*                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: (gridSize == GridSize.grid2x2)
                          ? Text("generated by Rankる",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14))
                          : Text("generated by Rankる",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  )*/
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
    );
  }
}
