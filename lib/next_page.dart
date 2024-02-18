import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

class NextPage extends StatelessWidget {
  NextPage(this.names, this.imgs);
  final List<String> names;
  final List<Image?> imgs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grid List",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyPage(
          title: 'Flutter Demo Home Page',
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
/*
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
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }
*/
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
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.5),
            child: RepaintBoundary(
              key: globalKey,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
                shrinkWrap: true,
                children: [
                  GridTile(
                    //child: Image.network("https://bokuyaba-anime.com/assets/img/top/kv03.jpg", fit: BoxFit.cover,),
                    child: Image(
                      image: widget.imgs[0]!.image,
                      fit: BoxFit.cover,
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        widget.names[0],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("1位"),
                    ),
                  ),
                  GridTile(
                    //child: Image.network("https://frieren-anime.jp/wp-content/themes/frieren_2023/assets/img/top/top/4_visual.jpg", fit: BoxFit.cover,),
                    child: Image(
                      image: widget.imgs[1]!.image,
                      fit: BoxFit.cover,
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        widget.names[1],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("2位"),
                    ),
                  ),
                  GridTile(
                    //child: Image.network("https://kimetsu.com/anime/mugenresshahen_tv/assets/img/kv.jpg", fit: BoxFit.cover,),
                    child: Image(
                      image: widget.imgs[2]!.image,
                      fit: BoxFit.cover,
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        widget.names[2],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("3位"),
                    ),
                  ),
                  GridTile(
                    //child: Image.network("https://bluelock-pr.com/tv1st/wp/wp-content/themes/bluelock-main/_assets/images/top/fv/v_1st.png?202303", fit: BoxFit.cover,),
                    child: Image(
                      image: widget.imgs[3]!.image,
                      fit: BoxFit.cover,
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        widget.names[3],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("4位"),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              child: FloatingActionButton(
                child: const Text("画像を保存する"),
                onPressed: () {
                  print(widget.names);
                  print(widget.imgs);
/*                  _rewardedAd?.show(onUserEarnedReward:
                      (AdWithoutView ad, RewardItem rewardItem) {
                    // ignore: avoid_print
                    print('Reward amount: ${rewardItem.amount}');
                  }); */
                  _saveImage(globalKey);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
