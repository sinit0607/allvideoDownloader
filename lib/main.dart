import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_downloader/localization/language_constants.dart';
import 'package:video_downloader/localization/localization_stuff.dart';
import 'package:video_downloader/ui/splash_screen.dart';
import 'package:video_downloader/utils/utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  theme.setMainColor(await theme.getColor());
  await iUtils.checkingInternet();

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(iUtils.oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

iUtils theme = iUtils();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int? storagePermissionCheck;
  Locale? _locale;

  static const platform = MethodChannel('apilevel');

  static Future<void> getApiLevel() async {
    print("SendSMS");
    try {
      iUtils.apiLevel = await platform.invokeMethod(
          'getapilevel'); //Replace a 'X' with 10 digit phone number
      print(iUtils.apiLevel);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Future<String> checkCookiesDl() async {
    Response response = await Dio().get(
        "http://video.infusiblecoder.com/code.php",
        queryParameters: {"code": iUtils.purchaseCode});
    print('res= ${response.data['code']}');
    return await response.data['code'];
  }

  Future<int> checkStoragePermission() async {
    PermissionStatus result = await Permission.storage.status;
    print("Checking Storage Permission " + result.toString());
    setState(() {
      storagePermissionCheck = 1;
    });
    if (result.toString() == 'PermissionStatus.denied') {
      return 0;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    permissionHandler();
    getApiLevel();
    checkCookiesDl().then((value) {
      print('res2_cc= $value');
      if (!value.contains("200")) {
        iUtils.howToGetCookies(context);
      }
    });
  }

  permissionHandler() async {
    if (await checkStoragePermission() == 0) {
      await [Permission.storage].request();
      print("Asking Permission Storage");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.myAppMainColor)),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'all_video_downloader_flutter',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: theme.myAppMainColor,
        ),
        locale: _locale,
        supportedLocales: const [
          Locale("en", "US"),
          Locale("ar", "SA"),
          Locale("hi", "IN")
        ],
        localizationsDelegates: const [
          LocalizationStuff.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },

        ///oldCode before Permission Work
        home: const VideoDownloaderMain(),
      );
    }
  }
}

class VideoDownloaderMain extends StatelessWidget {
  const VideoDownloaderMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SplashScreen(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
