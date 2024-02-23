import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Settings",
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
      home: Scaffold(
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
            SettingsSection(
              title: const Text("このアプリについて"),
              tiles: [
                SettingsTile.navigation(title: const Text("利用規約"), onPressed: (context) async {
                  const url = "https://scratch-nose-21e.notion.site/88543fd71229490491717a94bb623689?pvs=25";
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },),
                SettingsTile.navigation(title: const Text("プライバシーポリシー"), onPressed: (context) async {
                  const url = "https://scratch-nose-21e.notion.site/740b38b97b284efca52edad908ef6042?pvs=25";
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },),
              ]
            ),
          ]
        ),
      )
    );
  }
}
