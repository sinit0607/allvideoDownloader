import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_downloader/ui/imageScreen.dart';
import 'package:video_downloader/ui/videoScreen.dart';
import 'package:video_downloader/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  var platform = MethodChannel('apilevel');

  Future<List<dynamic>> getWhatsAppPermissionAndDir() async {
    print("SendSMS www");
    List result = [];
    try {
      result = await platform.invokeMethod('whatsapplist');
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
      return result;
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      //  getAllStatusData();
    } catch (e) {
      e.toString();
    }
  }

  getAllStatusData() async {
    iUtils.resultsFromWhatsaApp =
        await getWhatsAppPermissionAndDir().then((value) => value);
    print("length of statuses= ${iUtils.resultsFromWhatsaApp.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Passed BuildContext in function.
        bottomNavigationBar: TabBarView(
      children: [
        ImageScreen(),
        VideoScreen(),
      ],
    ));
  }
}
