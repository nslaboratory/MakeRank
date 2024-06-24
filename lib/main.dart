import 'dart:async';
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

  var pickedFile;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late TutorialCoachMark tutorialCoachMark;

  late StreamSubscription<ConnectivityResult> subscription;

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyImage = GlobalKey();
  GlobalKey keyTextBox = GlobalKey();

  final picker = ImagePicker();

  final controller0 = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();

  var textFieldList = ["", "", "", ""];
  List<Image?> imageList = [null, null, null, null];

  RewardedAd? _rewardedAd;

  final isDebug = true;
  final enableAd = true;

  var _adUnitId = "";

  @override
  void initState() {
    GlobalMethod().loadData();
    rank1Txt = visiblerank ? "1位" : "";

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
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ).then((value) {
                setState(() {
                  rank1Txt = visiblerank ? "1位" : "";
                  print(rank1Txt);
                });
              });
            },
          )
        ],
      ),
      backgroundColor: Color(0xFFF2F2F7),
      body: Stack(children: [
        ListView(
          children: [
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
                  },
                  decoration: InputDecoration(
                      labelText: rank1Txt,
                      floatingLabelBehavior: FloatingLabelBehavior.always),
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
                  },
                  decoration: const InputDecoration(
                      labelText: "2位",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
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
                  },
                  decoration: const InputDecoration(
                      labelText: "3位",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
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
                  },
                  decoration: const InputDecoration(
                      labelText: "4位",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                )),
          ],
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
                style: FilledButton.styleFrom(shape: BeveledRectangleBorder()),
                child: const Text(
                  "画像を生成",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: textFieldList.contains("") ||
                        imageList.contains(null)
                    ? null
                    : () async {
                        final connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
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
                                    builder: (context) =>
                                        NextPage(textFieldList, imageList))
                                    );
                          }
                        }
                      },
              ),
            ),
          ),
        )
      ]),
    );
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
      final imageForImage = Image.file(imageForFile);
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
                builder: (context) => NextPage(textFieldList, imageList)));
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

    return targets;
  }
}
