import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:make_rank/crop_image.dart';
import 'package:make_rank/next_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:make_rank/settings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool visiblerank = true;
var rank1Txt = "";
var rank2Txt = "";
var rank3Txt = "";
var rank4Txt = "";
var rank5Txt = "";
var rank6Txt = "";
var rank7Txt = "";
var rank8Txt = "";
var rank9Txt = "";

enum GridSize { grid2x2, grid3x3 }
//enum GridSize { grid2x2("grid2x2"), grid3x3("grid3x3") }
//enum GridSize {
//  grid2x2('2×2'), // Enumのメンバ宣言部分でフィールドも定義できる！
//  grid3x3('3×3'),
//  ;
//  const Align(this.displayName);

// フィールド生やし放題
//  final String displayName;
//}

GridSize gridSize = GridSize.grid2x2;

StreamController<bool> _controller = StreamController<bool>.broadcast();

// saveData() and loadData() for visiblerank
// saveData2() and loadData2() for gridSize
class GlobalMethod {
  Future<void> saveData(bool visiblerank) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("VisibleRank", visiblerank);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("VisibleRank") == null) {
      await saveData(true);
    }
    visiblerank = prefs.getBool("VisibleRank")!;
    rank1Txt = visiblerank ? "1位" : "";
    rank2Txt = visiblerank ? "2位" : "";
    rank3Txt = visiblerank ? "3位" : "";
    rank4Txt = visiblerank ? "4位" : "";
    rank5Txt = visiblerank ? "5位" : "";
    rank6Txt = visiblerank ? "6位" : "";
    rank7Txt = visiblerank ? "7位" : "";
    rank8Txt = visiblerank ? "8位" : "";
    rank9Txt = visiblerank ? "9位" : "";
    _controller.add(visiblerank);
  }

  Future<void> saveData2(GridSize gridSize) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("GridSize", gridSize.toString().split(".")[1]);
    // gridSize.toString() : GridSize.grid2x2 or GridSize.grid3x3
    // gridSize.toString().split(".")[1] : grid2x2 or grid3x3
    print("gridSize at saveData2() :");
    print(gridSize.toString().split(".")[1]);
  }

  Future<void> loadData2() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("GridSize") == null) {
      await saveData2(GridSize.grid2x2);
    }
    gridSize = GridSize.values.byName(prefs.getString("GridSize")!);
    print("gridSize at loadData2() :");
    print(gridSize);
//    _controller.add(visiblerank);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rankる',
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
      home: const MyHomePage(title: 'Rankる'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _image;
  Image? _image0;
  Image? _image1;
  Image? _image2;
  Image? _image3;
  Image? _image4;
  Image? _image5;
  Image? _image6;
  Image? _image7;
  Image? _image8;

  var pickedFile;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late TutorialCoachMark tutorialCoachMark;

  late StreamSubscription<ConnectivityResult> subscription;

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyImage = GlobalKey();
  GlobalKey keyTextBox = GlobalKey();
  GlobalKey keySettings = GlobalKey();

  final picker = ImagePicker();

  final controller0 = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();
  final controller5 = TextEditingController();
  final controller6 = TextEditingController();
  final controller7 = TextEditingController();
  final controller8 = TextEditingController();

  var textFieldList = ["", "", "", "", "", "", "", "", ""];
  List<Image?> imageList = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];
  List<int> imagelistflgs = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  RewardedAd? _rewardedAd;

  final isDebug = true;
  final enableAd = true;

  var _adUnitId = "";

//  Future<void> initLoadData() async {
//    await GlobalMethod().loadData();
//  }

  @override
  void initState() {
    GlobalMethod().loadData();
    GlobalMethod().loadData2();
//    initLoadData();
//    print("visiblerank : " + visiblerank.toString());
//    setState(() {
//      rank1Txt = visiblerank ? "1位" : "";
//    });

    if (isDebug) {
      _adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    } else {
      _adUnitId = Platform.isAndroid
          ? 'ca-app-pub-9700455591074338/2708915001'
          : 'ca-app-pub-9700455591074338/7926531754';
    }

    _prefs.then((SharedPreferences prefs) {
      var isTutorialed = prefs.getInt('isTutorial') ?? 0;
      if (isTutorialed == 0) {
        createTutorial();
        Future.delayed(Duration.zero, showTutorial);
      }
      if (enableAd) _loadAd();
    });
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && enableAd) _loadAd();
  }

  void _loadAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _loadAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadAd();
            },
            onAdClicked: (ad) {},
          );
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            key: keySettings,
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
                });
              });
            },
          )
        ],
      ),
      backgroundColor: Color(0xFFF2F2F7),
      body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            return Stack(children: [
//            return Column(children: [
//              (gridSize == GridSize.grid2x2)
//                  ?
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView(
                    children: (gridSize == GridSize.grid2x2)
                        ? [
                            ListTile(
                                leading: GestureDetector(
                                  key: keyImage,
                                  child: _image0 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image0,
                                  onTap: () {
                                    _getImage(0);
                                  },
                                ),
                                title: TextField(
                                  key: keyTextBox,
                                  controller: controller0,
                                  onChanged: (text) {
                                    textFieldList[0] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank1Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                  key: keyImage,
                                  child: _image1 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image1,
                                  onTap: () {
                                    _getImage(1);
                                  },
                                ),
                                title: TextField(
                                  controller: controller1,
                                  onChanged: (text) {
                                    textFieldList[1] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank2Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  child: _image2 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image2,
                                  onTap: () {
                                    _getImage(2);
                                  },
                                ),
                                title: TextField(
                                  controller: controller2,
                                  onChanged: (text) {
                                    textFieldList[2] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank3Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  child: _image3 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image3,
                                  onTap: () {
                                    _getImage(3);
                                  },
                                ),
                                title: TextField(
                                  controller: controller3,
                                  onChanged: (text) {
                                    textFieldList[3] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank4Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ))
                          ]
                        : [
                            ListTile(
                                leading: GestureDetector(
                                  key: keyImage,
                                  child: _image0 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image0,
                                  onTap: () {
                                    _getImage(0);
                                  },
                                ),
                                title: TextField(
                                  //                                style: TextStyle(
                                  //                                  fontSize: 15.0,
                                  //                                ),
                                  key: keyTextBox,
                                  controller: controller0,
                                  onChanged: (text) {
                                    textFieldList[0] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank1Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                  key: keyImage,
                                  child: _image1 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image1,
                                  onTap: () {
                                    _getImage(1);
                                  },
                                ),
                                title: TextField(
                                  controller: controller1,
                                  onChanged: (text) {
                                    textFieldList[1] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank2Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  child: _image2 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image2,
                                  onTap: () {
                                    _getImage(2);
                                  },
                                ),
                                title: TextField(
                                  controller: controller2,
                                  onChanged: (text) {
                                    textFieldList[2] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank3Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                                key: keyImage,
                                  child: _image3 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image3,
                                  onTap: () {
                                    _getImage(3);
                                  },
                                ),
                                title: TextField(
                                  //                                key: keyTextBox,
                                  controller: controller3,
                                  onChanged: (text) {
                                    textFieldList[3] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank4Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                  key: keyImage,
                                  child: _image4 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image4,
                                  onTap: () {
                                    _getImage(4);
                                  },
                                ),
                                title: TextField(
                                  controller: controller4,
                                  onChanged: (text) {
                                    textFieldList[4] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank5Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  child: _image5 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image5,
                                  onTap: () {
                                    _getImage(5);
                                  },
                                ),
                                title: TextField(
                                  controller: controller5,
                                  onChanged: (text) {
                                    textFieldList[5] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank6Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                                key: keyImage,
                                  child: _image6 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image6,
                                  onTap: () {
                                    _getImage(6);
                                  },
                                ),
                                title: TextField(
                                  //                                key: keyTextBox,
                                  controller: controller6,
                                  onChanged: (text) {
                                    textFieldList[6] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank7Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  //                  key: keyImage,
                                  child: _image7 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image7,
                                  onTap: () {
                                    _getImage(7);
                                  },
                                ),
                                title: TextField(
                                  controller: controller7,
                                  onChanged: (text) {
                                    textFieldList[7] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank8Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                )),
                            ListTile(
                                leading: GestureDetector(
                                  child: _image8 == null
                                      ? const Icon(Icons.image, size: 30)
                                      : _image8,
                                  onTap: () {
                                    _getImage(8);
                                  },
                                ),
                                title: TextField(
                                  controller: controller8,
                                  onChanged: (text) {
                                    textFieldList[8] = text;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      labelText: rank9Txt,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ))
                          ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: FilledButton(
                      key: keyButton,
                      style: FilledButton.styleFrom(
                          shape: BeveledRectangleBorder()),
                      child: const Text(
                        "画像を生成",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: enableBtn()
                          ? () async {
                              final connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                Fluttertoast.showToast(msg: "インターネット接続がありません");
                              } else {
                                print(textFieldList);
                                print(imageList);
                                if (enableAd) {
                                  _showDialog();
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NextPage(
                                              textFieldList,
                                              imageList,
                                              imagelistflgs))).then((value) {
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
                                    });
                                  });
                                }
                              }
                            }
                          : null,
                    ),
                  ),
                ),
              )
            ]);
          }),
    );
  }

  bool enableBtn() {
/*    for (var value in imageList) {
      if (value != null) {
        imagelistflgs.add(1);
      } else {
        imagelistflgs.add(0);
      }
    }*/
    for (int i = 0; i < imageList.length; i++) {
      if (imageList[i] != null) {
        imagelistflgs[i] = 1;
      } else {
        imagelistflgs[i] = 0;
      }
    }
    // tmpにはn-1回目のimagelistflgsの値を入れる
    var tmp = 0;
    var count = 0;
    for (int i = 0; i < imagelistflgs.length; i++) {
      print("i=" + i.toString());
      print(textFieldList[i]);
      if (imagelistflgs[i] == 1 && (textFieldList[i].length == 0)) {
        return false;
      }

      if (imagelistflgs[i] == 0 && (textFieldList[i].length != 0)) {
        return false;
      }

      if (imagelistflgs[i] == 0) {
        count += 1;
      }
      if (count == imagelistflgs.length) {
        // 全てimageがnullの場合
        return false;
      }

      if (i == 0) {
        tmp = imagelistflgs[i];
        continue;
      }
      if (tmp < imagelistflgs[i]) {
        // null -> image になった場合
        return false;
      }
      tmp = imagelistflgs[i];
    }
    return true;
  }

  Future _getImage(int i) async {
//    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => CropSample()));
    var path = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CropSample()));

//    pickedFile = await picker.pickImage(source: ImageSource.gallery);
//    if (pickedFile == null) return;
    XFile? _image = null; // = await _cropImage();
//    if (_image == null) return;

    if (path == "") {
      print('No image selected.');
      return;
    } else {
      _image = XFile(path);
    }

    setState(() {
//      if (pickedFile != null) {
//        _image = XFile(pickedFile.path);
      final imageForFile = File(_image!.path);
      final imageForImage = Image.file(
        imageForFile,
//        height: 30,
//        width: 30,
      );
      if (i == 0) {
        _image0 = imageForImage;
        imageList[0] = _image0;
      } else if (i == 1) {
        _image1 = imageForImage;
        imageList[1] = _image1;
      } else if (i == 2) {
        _image2 = imageForImage;
        imageList[2] = _image2;
      } else if (i == 3) {
        _image3 = imageForImage;
        imageList[3] = _image3;
      } else if (i == 4) {
        _image4 = imageForImage;
        imageList[4] = _image4;
      } else if (i == 5) {
        _image5 = imageForImage;
        imageList[5] = _image5;
      } else if (i == 6) {
        _image6 = imageForImage;
        imageList[6] = _image6;
      } else if (i == 7) {
        _image7 = imageForImage;
        imageList[7] = _image7;
      } else if (i == 8) {
        _image8 = imageForImage;
        imageList[8] = _image8;
      }
//      } else {
//        print('No image selected.');
//      }
    });
  }

  Future _showDialog() async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text('画像を生成する'),
        content: new Text('広告を最後まで視聴すると画像を1回生成できます。'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          new SimpleDialogOption(
            child: new Text('No'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
    );
    if (value) {
      print("広告にとぶ");
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        print('Reward amount: ${rewardItem.amount}');
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NextPage(textFieldList, imageList, imagelistflgs)))
            .then((value) {
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
          });
        });
      });
    } else {
      print("広告にとばない");
    }
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
        _prefs.then((SharedPreferences prefs) {
          prefs.setInt('isTutorial', 1);
        });
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyImage",
        keyTarget: keyImage,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ランキングの生成に使用する\n画像を4枚選択します",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyTextBox",
        keyTarget: keyTextBox,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.only(left: 50),
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ランキングの生成に使用する\nテキストを4ヶ所入力します",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keyButton",
        keyTarget: keyButton,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "すべての項目が入力されていることを確認し\n「画像を生成」をタップします\n※インターネット接続が必要です",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "keySettings",
        keyTarget: keySettings,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            padding: EdgeInsets.only(top: 40, right: 10),
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "その他の設定項目は、\nこのボタンから設定できます",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}
