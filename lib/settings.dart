import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:make_rank/main.dart';

class Settings extends StatefulWidget {
//  Settings(this.names, this.imgs);

//  final List<String> names;
//  final List<Image?> imgs;

  @override
  State<Settings> createState() => _MyPageState();
}

class _MyPageState extends State<Settings> {
//  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SettingsList(
          lightTheme: const SettingsThemeData(
            settingsListBackground: Color(0xFFF2F2F7),
            settingsSectionBackground: Colors.white,
          ),
          contentPadding: const EdgeInsets.all(10.0),
          sections: [
            SettingsSection(title: const Text("レイアウト設定"), tiles: [
              SettingsTile.switchTile(
//                leading: const FlutterLogo(),
                title: const Text('順位を表示'),
//                description: const Text('description'),
                initialValue: visiblerank,
                onToggle: (value) {
                  visiblerank = value;
                  setState(() {});
                  GlobalMethod().saveData(value);
                },
              )
            ]),
            SettingsSection(title: const Text("このアプリについて"), tiles: [
              SettingsTile.navigation(
                title: const Text("利用規約"),
                onPressed: (context) async {
                  const url =
                      "https://scratch-nose-21e.notion.site/88543fd71229490491717a94bb623689?pvs=25";
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
              SettingsTile.navigation(
                title: const Text("プライバシーポリシー"),
                onPressed: (context) async {
                  const url =
                      "https://scratch-nose-21e.notion.site/740b38b97b284efca52edad908ef6042?pvs=25";
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
            ]),
          ]),
    );
  }
}
