import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_downloader/ui/download_page_main.dart';
import 'package:video_downloader/ui/settingScreen.dart';
import 'package:video_downloader/ui/supported_wesites.dart';
import 'package:video_downloader/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../utils/adsmanager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int mindex = 0;
  List<Widget> myPages = [
    const DownloadPageMain(),
    Supported_websitespage(),
    SettingScreen(),
  ];

  bool connected = false;

  late BannerAdListener bannerAdListener;
  BannerAd? _anchoredBanner;

  static const platform = MethodChannel('apilevel');

  static Future<void> getWhatsAppPermissionAndDir() async {
    print("SendSMS www");
    try {
      // print(await platform.invokeMethod('whatsapp'));
      final List result = await platform.invokeMethod('whatsapp');
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.myAppMainColor,
    ));

    getExternalStorage();
    checkingInternet();
    // getWhatsAppPermissionAndDir();
    bannerAdListener = BannerAdListener(
      onAdLoaded: (Ad ad) {
        print('$BannerAd loaded.');
        setState(() {
          _anchoredBanner = ad as BannerAd?;
        });
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('$BannerAd failedToLoad: $error');
        ad.dispose();
      },
      onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
      onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
    );
    super.initState();
  }

  getExternalStorage() async {
    if (Platform.isAndroid) {
      var sdkInt = await int.parse(iUtils.apiLevel);
      print(sdkInt);
      if (sdkInt >= 30) {
        await Permission.manageExternalStorage.request();
      }
    }
  }

  @override
  void dispose() {
    _anchoredBanner?.dispose();
    super.dispose();
  }

  checkingInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;

        setState(() {});
      }
    } on SocketException catch (_) {
      //print('not connected');
      connected = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AdsManager.loadingAnchoredBanner) {
      AdsManager.loadingAnchoredBanner = true;
      AdsManager.createAnchoredBanner(context, bannerAdListener);
    }

    return Scaffold(
      body: myPages[mindex],
      bottomNavigationBar: SizedBox(
        height: connected ? 125 : 75,
        child: Column(
          children: [
            CurvedNavigationBar(
              animationCurve: Curves.ease,
              backgroundColor: theme.myAppMainColor.withOpacity(0.1),
              color: theme.myAppMainColor,
              buttonBackgroundColor: theme.myAppMainColor,
              items: <Widget>[
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/settings_icons/download.png"),
                    )),
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                          "assets/settings_icons/moreapps_white.png"),
                    )),
                SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                          "assets/settings_icons/settings_white.png"),
                    )),
              ],
              onTap: (index) {
                setState(() {
                  mindex = index;
                });
              },
            ),
            (connected)
                ? Container(
                    alignment: Alignment.center,
                    child: _anchoredBanner != null
                        ? AdWidget(ad: _anchoredBanner!)
                        : Container(),
                    height: 50,
                  )
                : Container(),
            // Container(
            //   height: 50,
            // )
          ],
        ),
      ),
    );
  }
}
