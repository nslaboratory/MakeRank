import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:make_rank/next_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
//        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
//        brightness: Brightness.light,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  final picker = ImagePicker();

  final controller0 = TextEditingController();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();

  var textFieldList = ["", "", "", ""];
  List<Image?> imageList = [null, null, null, null];

  RewardedAd? _rewardedAd;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    super.initState();

    _loadAd();
  }

  /// Loads a rewarded ad.
  void _loadAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _loadAd();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadAd();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        ListView(
          children: [
            ListTile(
                leading: GestureDetector(
                  child: _image0 == null
                      ? const Icon(Icons.image, size: 30)
                      : _image0,
                  onTap: () {
                    _getImage(0);
                  },
                ),
                title: TextField(
                  controller: controller0,
                  onChanged: (text) {
                    textFieldList[0] = text;
                  },
                  decoration: InputDecoration(
                      labelText: "1位",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                )),
            ListTile(
                leading: GestureDetector(
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
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              //            child: ElevatedButton(
              child: FilledButton(
                style: FilledButton.styleFrom(shape: BeveledRectangleBorder()),
                child: const Text(
                  "画像を生成",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed:
                    textFieldList.contains("") || imageList.contains(null)
                        ? null
                        : () {
//                        textFieldList[0] = controller0.text;
//                        textFieldList[1] = controller1.text;
//                        textFieldList[2] = controller2.text;
//                        textFieldList[3] = controller3.text;
                            print(textFieldList);
                            print(imageList);
//                        print(_image0);
//                        print(_image1);
//                        print(_image2);
//                        print(_image3);
//                        imageList[0] = _image0;
//                        imageList[1] = _image1;
//                        imageList[2] = _image2;
//                        imageList[3] = _image3;

                            _rewardedAd?.show(onUserEarnedReward:
                                (AdWithoutView ad, RewardItem rewardItem) {
                              // ignore: avoid_print
                              print('Reward amount: ${rewardItem.amount}');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NextPage(textFieldList, imageList)));
                            });
                          },
              ),
            ),
          ),
        )
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _getImage(int i) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
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
      } else {
        print('No image selected.');
      }
    });
  }
}
