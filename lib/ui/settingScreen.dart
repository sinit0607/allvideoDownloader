import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_downloader/localization/language_constants.dart';
import 'package:video_downloader/main.dart';
import 'package:video_downloader/ui/about_us.dart';
import 'package:video_downloader/ui/color_picker_dialog.dart';
import 'package:video_downloader/ui/gallery.dart';
import 'package:video_downloader/ui/status_saver_main.dart';
import 'package:video_downloader/utils/utils.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void changeLanguage(String langcode) async {
    Locale _locale = await setLocale(langcode);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: Icon(
          AntDesign.setting,
          color: Color(0xFF535660),
        ),
        title: Text(
          "Settings",
          style: TextStyle(color: Color(0xFF535660)),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backImage.jpg'),
                fit: BoxFit.cover),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: theme.myAppMainColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 190,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // itemBuild("Gallery","assets/settings_icons/gallery.png",galleryAction),
                            // itemBuild("Status Saver","assets/settings_icons/demovideo.png",statusSaverAction),
                            itemBuild(getTranslated(context, "Gallery")!,
                                Icons.videocam_outlined, galleryAction),
                            itemBuild(getTranslated(context, "Status Saver")!,
                                FlutterIcons.youtube_fea, statusSaverAction),
                            itemBuild(
                                getTranslated(context, "Change Language")!,
                                Icons.language,
                                onChangeLanguage),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 240,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            itemBuild(getTranslated(context, "Theme")!,
                                Icons.color_lens_sharp, onThemeTap),
                            itemBuild(getTranslated(context, "More Apps")!,
                                Icons.dashboard_outlined, moreAppsAction),
                            itemBuild(
                                getTranslated(context, "Share with Friends")!,
                                Entypo.share,
                                shareAction),
                            itemBuild(getTranslated(context, "Rate this App")!,
                                AntDesign.star, rateThisApp),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: 240,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            itemBuild(getTranslated(context, "How to Use")!,
                                Entypo.help, howToUseAction),
                            itemBuild(getTranslated(context, "Feedback")!,
                                FlutterIcons.email_outline_mco, feedBackAction),
                            itemBuild(getTranslated(context, "About Us")!,
                                Feather.info, aboutUsAction),
                            itemBuild(getTranslated(context, "Privacy Policy")!,
                                CupertinoIcons.person, privacyPolicyAction),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  itemBuild(String title, IconData icon, Function() action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        child: ListTile(
          leading: Container(
            width: 25,
            height: 25,
            // child: Image.asset(icon)
            child: Icon(
              icon,
              color: theme.myAppMainColor,
            ),
          ),
          title: Text(title),
        ),
      ),
    );
  }

  shareAction() {
    Share.share(
        getTranslated(context, 'mydrawar_checkall')! +
            "\n\nhttps://play.google.com/store/apps/details?id=" +
            packageInfo!.packageName,
        subject: getTranslated(context, 'supportedpage_lookwhats'));
  }

  PackageInfo? packageInfo;

  rateThisApp() async {
    String packageName = packageInfo!.packageName;
    var url = 'https://play.google.com/store/apps/details?id=' + packageName;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  packageInfoInitializer() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  aboutUsAction() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
  }

  privacyPolicyAction() async {
    var url = iUtils.url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  feedBackAction() async {
    var url =
        'mailto:${iUtils.developerEmail}?subject=Feedback&body=Type your feedback here';
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    // throw 'Could not launch $url';
    // }
  }

  @override
  void initState() {
    super.initState();
    packageInfoInitializer();
  }

  howToUseAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(data: iUtils.html),
                    Expanded(
                      child: new Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  moreAppsAction() async {
    var url =
        'https://play.google.com/store/apps/developer?id=${iUtils.developerId}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  galleryAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GalleryVideos()));
  }

  statusSaverAction() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StatussaverHome()));
  }

  onThemeTap() {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false, pageBuilder: (context, _, __) => ColorDialog()));
  }

  onChangeLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Select Language'),
              content: Container(
                height: 200.0, // Change as per your requirement
                width: 220.0, // Change as per your requirement
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: iUtils.supportedLangList.length,
                  itemBuilder: (BuildContext itemcontext, int index) {
                    return ListTile(
                      title: GestureDetector(
                          onTap: () {
                            if (iUtils.supportedLangList[index] == "Arabic") {
                              changeLanguage("ar");
                            } else if (iUtils.supportedLangList[index] ==
                                "Hindi") {
                              changeLanguage('hi');
                            } else {
                              changeLanguage('en');
                            }

                            Navigator.pop(context);
                          },
                          child: Text(iUtils.supportedLangList[index])),
                    );
                  },
                ),
              ));
        });
  }
}
