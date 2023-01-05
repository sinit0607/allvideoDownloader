import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_downloader/localization/language_constants.dart';
import 'package:video_downloader/ui/galleryImageGrid.dart';
import 'package:video_downloader/utils/utils.dart';

import '../main.dart';
import 'galleryVideoGrid.dart';

GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

class GalleryVideos extends StatefulWidget {
  @override
  GalleryVideosScreenState createState() => new GalleryVideosScreenState();
}

class GalleryVideosScreenState extends State<GalleryVideos> {
  bool isLoading = true;
  var videoList;
  Directory _videoSaveDir = Directory("");

  setDirectory() async {
    Directory? iosDirectory;
    if (Platform.isIOS) {
      iosDirectory = await getApplicationDocumentsDirectory();
    }
    _videoSaveDir = Platform.isAndroid
        ? new Directory(
            '/storage/emulated/0/Download/' + iUtils.nameModifier + '/')
        : Directory(iosDirectory!.path + "/" + iUtils.nameModifier + '/');
  }

  @override
  // ignore: must_call_super
  void initState() {
    setDirectory();
    new Timer(const Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_videoSaveDir.path}").existsSync()) {
      return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "Gallery")!),
          automaticallyImplyLeading: true,
          backgroundColor: theme.myAppMainColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: Text(
              getTranslated(context, "gallery_novids")!,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey2,
          appBar: AppBar(
            title: Text(
              "Gallery",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: theme.myAppMainColor,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white)),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: theme.myAppMainColor,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              tabs: [
                Container(
                    height: 40,
                    child: Center(
                        child: Text(
                      "Images",
                    ))),
                Container(
                    height: 40,
                    child: Center(
                        child: Text(
                      "Videos",
                    ))),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              new GalleryImagesGrid(directory: _videoSaveDir),
              new GalleryVideosGrid(
                directory: _videoSaveDir,
              ),
            ],
          ),
        ),
      );
    }
  }
}
