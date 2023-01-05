import 'dart:io';
import 'package:video_downloader/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_downloader/ui/dashboard.dart';

import '../main.dart';

GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class StatussaverHome extends StatefulWidget {
  @override
  _StatussaverHomeState createState() => _StatussaverHomeState();
}

class _StatussaverHomeState extends State<StatussaverHome> {
  var sdkInt = 30;

  getDirectory() async {
    if (Platform.isAndroid) {
      sdkInt = await int.parse(iUtils.apiLevel);
    } else {
      sdkInt = 30;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
            // Added
            length: 2,
            // Added
            initialIndex: 0,
            //Added
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Status Saver'),
                backgroundColor: theme.myAppMainColor,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(
                            'check out whatsapp status downloader ' +
                                iUtils.nameModifier,
                            subject: 'Look what I made!');
                      }),
                ],
                bottom: TabBar(tabs: [
                  Container(
                    height: 35.0,
                    child: Center(
                      child: Text(
                        'IMAGES',
                      ),
                    ),
                  ),
                  Container(
                    height: 35.0,
                    child: Center(
                      child: Text(
                        'VIDEOS',
                      ),
                    ),
                  ),
                ]),
              ),
              body: Dashboard(),
              backgroundColor: Colors.white,
            )));
  }
}
