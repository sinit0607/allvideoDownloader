import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class iUtils {
  static bool isYTDAvailable = true;
  static final version = '3.0';
  static final String nameModifier = "all_video_downloader_flutter";
  static final String apiUrl = "http://dlapi.infusiblecoder.com:9191/api/info";

  static const String url = "https://picsart.com/privacy-policy";
  static const String oneSignalAppId = "8eafd9a4-56db-4f47-809e-27e2677bb856";

  // TODO Enter Your Purchase Code Here. like this ('"00000-000-000-00000-000"') below.
  // TODO To Get Purchase Code Open Downloads Sections and Download the License
  // TODO link: https://codecanyon.net/downloads
  // TODO https://help.market.envato.com/hc/en-us/articles/202822600-Where-Is-My-Purchase-Code-
  static const String purchaseCode = "448f80e2-9f54-4974-9438-320a312341a6";

  // static final Color myAppMainColor = Color(0xff54536A);
  Color myAppMainColor = Color(0xffC60000);
  //Color(0xffD0313D);
  static final Color myAppAccentColor = Color(0xff78CABC);
  //Color(0xffff8c8a);
  static final Color myAppNavigationIconColor = Color(0xff757575);

  static final String developerEmail = "infusiblecoder@gmail.com";

  static final String developerId = '5282937391665595743';

  static final String html =
      "<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>";

  setMainColor(Color color) async {
    myAppMainColor = color;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("color", color.value);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: theme.myAppMainColor,));
  }

  Future<Color> getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('color')) {
      return Color(prefs.getInt("color")!);
    } else {
      return myAppMainColor;
    }
  }

  static Future<String?> getAppDetails(String detailname) async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      switch (detailname) {
        case "appname":
          {
            return packageInfo.appName.toString();
          }
        case "packedgename":
          {
            return packageInfo.packageName.toString();
          }
        case "version":
          {
            return packageInfo.version.toString();
          }
        case "buildnumber":
          {
            return packageInfo.buildNumber.toString();
          }
        default:
          {
            return "all_video_downloader_flutter";
          }
      }
    });
  }

  static showToast(BuildContext context, var test) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(test),
        ),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  static final supportedLangList = ["English", "Hindi", "Arabic"];

  static getMyDownloadDirectory() async {
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download/";
    } else if (Platform.isIOS) {
      Directory mPath = await getApplicationDocumentsDirectory();
      return mPath.path + "/";
    }
  }

  static bool isConnected = false;
  static List resultsFromWhatsaApp = [];
  static checkingInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
  }

  static String apiLevel = "30";

  static howToGetCookies(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: new Text(
                  "Your License is not valid kindly enter correct purchase code in the utils/utils.dart file, your app will close now"),
              content: new SingleChildScrollView(
                child: Container(),
              ),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text("OK"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ));
      },
    );
  }
}
