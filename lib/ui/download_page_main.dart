import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:video_downloader/localization/language_constants.dart';
import 'package:video_downloader/models/newModel.dart';
import 'package:video_downloader/ui/instagram_stories.dart';
import 'package:video_downloader/utils/adsmanager.dart';
import 'package:video_downloader/utils/utils.dart';
import 'package:video_downloader/web_services/chingari.dart';
import 'package:video_downloader/web_services/dlphp_api.dart';
import 'package:video_downloader/web_services/espn.dart';
import 'package:video_downloader/web_services/facebook.dart';
import 'package:video_downloader/web_services/imdb.dart';
import 'package:video_downloader/web_services/instagram.dart';
import 'package:video_downloader/web_services/josh.dart';
import 'package:video_downloader/web_services/likee.dart';
import 'package:video_downloader/web_services/linkedin.dart';
import 'package:video_downloader/web_services/mitron.dart';
import 'package:video_downloader/web_services/moj.dart';
import 'package:video_downloader/web_services/mx_takatak.dart';
import 'package:video_downloader/web_services/ropso.dart';
import 'package:video_downloader/web_services/sharechat.dart';
import 'package:video_downloader/web_services/tiktok.dart';
import 'package:video_downloader/web_services/twitter.dart';
import 'package:video_downloader/widgets/progress_dialog/src/progress_dialog.dart';

import '../main.dart';

class DownloadPageMain extends StatefulWidget {
  const DownloadPageMain({Key? key}) : super(key: key);

  @override
  _DownloadPageMainState createState() => _DownloadPageMainState();
}

class _DownloadPageMainState extends State<DownloadPageMain> {
  ProgressDialog? pr;
  AlertDialog? alert;
  var instaStoryReelFeedData;
  NewApiParser? apiParser;
  bool showBottomSheetForDownload = false;
  StreamSubscription? _intentDataStreamSubscription;
  TextEditingController? downloadUrlController = TextEditingController();

  @override
  void dispose() {
    _intentDataStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    iUtils.checkingInternet();

    setState(() {});
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      downloadUrlController!.text = value;
      //print('\n\n\nComming value when in memory is $value\n\n\n');
      if (value != null) {
        if (iUtils.isConnected) {
          getDownloadLinkData();
        }
      }
    }, onError: (err) {
      //print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        downloadUrlController!.text = value;
        value != "" ? getDownloadLinkData() : null;
      }
    });

    if (iUtils.isConnected) {
      AdsManager.createInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Download,
        isDismissible: false,
        showLogs: false);
    pr!.style(
        message: getTranslated(context, "download_downloadingtext")!,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            getTranslated(context, "Home")!,
            style: const TextStyle(color: Color(0xFF535660)),
          ),
          leading: const Icon(
            Icons.home_outlined,
            color: Color(0xFF535660),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/backImage.jpg'),
                fit: BoxFit.cover),
          ),
          child: Container(
            color: theme.myAppMainColor.withOpacity(0.05),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter,
                            //     colors: [
                            //       Colors.white,
                            //       // Colors.white,
                            //       Colors.grey.shade100
                            //     ]
                            // ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 15,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextField(
                                controller: downloadUrlController,
                                obscureText: false,
                                onSubmitted: (input) async {
                                  if (iUtils.isConnected) {
                                    getDownloadLinkData();
                                  } else {
                                    showToast(
                                        context, "No Internet Connection");
                                  }
                                },
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
                                  prefixIcon: GestureDetector(
                                    onTap: () async {
                                      ClipboardData? data =
                                          await Clipboard.getData('text/plain');
                                      downloadUrlController!.text =
                                          data!.text.toString();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await iUtils.checkingInternet();
                                      if (iUtils.isConnected) {
                                        getDownloadLinkData();
                                      } else {
                                        showToast(
                                            context, "No Internet Connection");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Container(
                                        margin: const EdgeInsets.all(3),
                                        width: 50,
                                        child: Icon(
                                          Icons.paste,
                                          color: theme.myAppMainColor,
                                          size: 30,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(3),
                                              right: Radius.circular(3)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: getTranslated(
                                      context, 'download_entrurl'),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 15,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -100,
                                right: -100,
                                child: ClipRRect(
                                  // clipper: RoundedDiagonalPathClipper(),
                                  borderRadius: BorderRadius.circular(500),
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color:
                                          theme.myAppMainColor.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -50,
                                left: -50,
                                child: ClipRRect(
                                  // clipper: RoundedDiagonalPathClipper(),
                                  borderRadius: BorderRadius.circular(500),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color:
                                          theme.myAppMainColor.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(
                                          context, 'how_to_download?')!,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: theme.myAppMainColor,
                                          child: const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(context, 'copy_link')!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    customListTile(
                                        number: getTranslated(context, '01'),
                                        description: getTranslated(
                                            context, 'Open_share_icons')),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: theme.myAppMainColor,
                                          child: const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(
                                              context, 'paste_it_above')!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    customListTile(
                                        number: getTranslated(context, '02'),
                                        description: getTranslated(context,
                                            'Paste copy link in above field')),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: theme.myAppMainColor,
                                          child: const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          getTranslated(
                                              context, 'download_is_ready')!,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    customListTile(
                                        number: getTranslated(context, '03'),
                                        description: getTranslated(context,
                                            'Click on download to enjoy your watermark free internet video')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InstagramStories()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  getTranslated(
                                      context, 'get_instagram_stories')!,
                                  style: const TextStyle(color: Colors.black),
                                )),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 15,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                handleBottomSheet(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet(ScrollController controller, NewApiParser apiParser) {
    String duration;
    try {
      duration = Duration(seconds: apiParser.videos![0].duration)
          .toString()
          .split(".")[0];
    } catch (e) {
      duration = " NAN";
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: controller,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0.7, 0.7))
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        height: MediaQuery.of(context).size.height * 0.88,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12, blurRadius: 3, spreadRadius: 2)
                  ]),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    showBottomSheetForDownload = false;
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
            ),
            ListTile(
              leading: Container(
                width: 100,
                child: Image.network(
                  apiParser.videos![0].thumbnail,
                  fit: BoxFit.fill,
                ),
              ),
              title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: getTranslated(context, 'title'),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: apiParser.videos![0].title,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
              subtitle: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: getTranslated(context, 'duration'),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: duration,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
            ListTile(
              leading: Text(
                getTranslated(context, 'select_quality')!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                getTranslated(context, 'source')!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
              trailing: Text(apiParser.videos![0].extractorKey.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            videoInfoPanel(),
            videoDownloadableList(),
          ],
        ),
      ),
    );
  }

  void getDownloadLinkData() async {
    //print(downloadUrlController.text);

    try {
      if (downloadUrlController!.text.isNotEmpty &&
          downloadUrlController!.text.contains("http")) {
        AdsManager.showInterstitialAd();

        if (downloadUrlController!.text.contains("instagram")) {
          InstagramLinkDownloader myInsta = InstagramLinkDownloader();
          try {
            await pr!.show();
            await myInsta.downloadVideo(downloadUrlController!.text, context);
            await pr!.hide();
          } catch (e) {
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("twitter")) {
          try {
            if (Platform.isAndroid || Platform.isIOS) {
              await pr!.show();
            }
            apiParser = await DlPhpApi.downloadVideo(
                downloadUrlController!.text, "twitter");
            //print(apiParser.url);
            await pr!.hide();
            setState(() {
              showBottomSheetForDownload = true;
            });
          } catch (e) {
            print(e);
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        }

        ///todo implement Facebook
        else if (downloadUrlController!.text.contains("facebook") ||
            downloadUrlController!.text.contains("fb.watch")) {
          try {
            if (Platform.isAndroid || Platform.isIOS) {
              await pr!.show();
            }
            apiParser = await DlPhpApi.downloadVideo(
                downloadUrlController!.text, "facebook");
            //print(apiParser.url);
            await pr!.hide();
            setState(() {
              showBottomSheetForDownload = true;
            });
          } catch (e) {
            print(e);
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("roposo")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          try {
            String downloadUrl = await RoposoVideoDownloader.downloadVideo(
                downloadUrlController!.text);
            webServiceDownloader(downloadUrl, "roposo");
          } catch (e) {
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("chingari")) {
          if (Platform.isAndroid || Platform.isIOS) {
            await pr!.show();
          }
          print("workin 1");
          try {
            String downloadUrl = await ChingariVideoDownloader.downloadVideo(
                downloadUrlController!.text);
            webServiceDownloader(downloadUrl, "chingari");
          } catch (e) {
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("moj")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          try {
            String downloadUrl = await MojVideoDownloader.downloadVideo(
                downloadUrlController!.text);
            webServiceDownloader(downloadUrl, "moj");
          } catch (e) {
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("sharechat")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await ShareChatVideoDownloader.downloadVideo(
              downloadUrlController!.text);
          webServiceDownloader(downloadUrl, "shareChat");
        } else if (downloadUrlController!.text.contains("mitron.tv")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await MitronVideoDownloader.downloadVideo(
              downloadUrlController!.text);
          webServiceDownloader(downloadUrl, "mitron.tv");
        } else if (downloadUrlController!.text.contains("likee")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await LikeeVideoDownloader.downloadVideo(
              downloadUrlController!.text, context);
          webServiceDownloader(downloadUrl, "likee");
        } else if (downloadUrlController!.text.contains("takatak")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await MxTakaTakVideoDownloader.downloadVideo(
              downloadUrlController!.text);
          webServiceDownloader(downloadUrl, "takatak");
        } else if (downloadUrlController!.text.contains("josh")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await JoshVideoDownloader.downloadVideo(
              downloadUrlController!.text);
          webServiceDownloader(downloadUrl, "josh");
        } else if (downloadUrlController!.text.contains("linkedin")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await LinkedInVideoDownloader.downloadVideo(
              downloadUrlController!.text);
          webServiceDownloader(downloadUrl, "linkedin");
        } else if (downloadUrlController!.text.contains("imdb")) {
          try {
            if (Platform.isAndroid || Platform.isIOS) {
              await pr!.show();
            }
            apiParser = await DlPhpApi.downloadVideo(
                downloadUrlController!.text, "imdb");
            //print(apiParser.url);
            await pr!.hide();
            setState(() {
              showBottomSheetForDownload = true;
            });
          } catch (e) {
            print(e);
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else if (downloadUrlController!.text.contains("espn")) {
          if (Platform.isAndroid || Platform.isIOS) {
            //print("workin 1");
            await pr!.show();
          }
          String downloadUrl = await ESPNVideoDownloader.downloadVideo(
              downloadUrlController!.text, "imdb");
          webServiceDownloader(downloadUrl, "espm");
        } else if (downloadUrlController!.text.contains("tiktok")) {
          try {
            if (Platform.isAndroid || Platform.isIOS) {
              await pr!.show();
            }
            apiParser = await DlPhpApi.downloadVideo(
                downloadUrlController!.text, "tiktok");
            //print(apiParser.url);
            await pr!.hide();
            setState(() {
              showBottomSheetForDownload = true;
            });
          } catch (e) {
            print(e);
            showToast(context, getTranslated(context, "download_error_url"));
            await pr!.hide();
          }
        } else {
          if (downloadUrlController!.text.contains("youtu.be") ||
              downloadUrlController!.text.contains("youtube")) {
            print(iUtils.isYTDAvailable);
            if (iUtils.isYTDAvailable) {
              try {
                if (Platform.isAndroid || Platform.isIOS) {
                  await pr!.show();
                }
                apiParser = await DlPhpApi.downloadVideo(
                    downloadUrlController!.text, "source");
                //print(apiParser.url);
                await pr!.hide();
                setState(() {
                  showBottomSheetForDownload = true;
                });
              } catch (e) {
                print(e);
                showToast(
                    context, getTranslated(context, "download_error_url"));
                await pr!.hide();
              }
            } else {
              showToast(context, getTranslated(context, "download_error_url"));
              await pr!.hide();
            }
          } else {
            try {
              if (Platform.isAndroid || Platform.isIOS) {
                await pr!.show();
              }
              apiParser = await DlPhpApi.downloadVideo(
                  downloadUrlController!.text, "source");
              //print(apiParser.url);
              await pr!.hide();
              setState(() {
                showBottomSheetForDownload = true;
              });
            } catch (e) {
              //print(e);
              showToast(context, getTranslated(context, "download_error_url"));
              await pr!.hide();
            }
          }
        }
      } else {
        showToast(context, getTranslated(context, "download_error_url"));
        await pr!.hide();
      }
    } catch (e) {
      showToast(context, getTranslated(context, "download_error_url"));
      await pr!.hide();
    }
  }

  Future downloadFile12(String url, String savePath) async {
    String errorMessage =
        "Can not fetch data for the link provided. Try again with another link.";
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        //print("workin 1");
        await pr!.show();
      }
      try {
        Response response = await Dio().download(
          url,
          savePath,
        );
        if (response.statusCode == 200) {
          await showToast(context,
              getTranslated(context, "download_complete")! + savePath + "\"");
          await pr!.hide();
        }
      } on DioError catch (ex) {
        if (ex.type == DioErrorType.other) {
          print("ex type" + ex.type.toString());
          print("Dio type" + ex.type.toString());
          pr!.hide();
          errorMessage =
              "Connection Time Out\nPlease check your internet connection";
        }
        throw Exception(ex.message);
      }
      print("Download Completed");
    } catch (e) {
      try {
        final downloaderUtils = DownloaderUtils(
          progressCallback: (current, total) {
            final progress = (current / total) * 100;
            if (progress % 10 == 0) {
              //print('Downloading: $progress');
            }
          },
          file: File(savePath),
          progress: ProgressImplementation(),
          onDone: () async {
            await showToast(context,
                getTranslated(context, "download_complete")! + savePath + "\"");
            await pr!.hide();
          },
          deleteOnCancel: true,
        );
        await Flowder.download(url, downloaderUtils);
      } catch (e2) {
        await pr!.hide();
        showToast(context, errorMessage);
      }
    }
  }

  webServiceDownloader(String url, String source) async {
    if (url != null) {
      String tempDir = await iUtils.getMyDownloadDirectory();
      print("tempDir>>>>" + tempDir);
      String halfpath = tempDir + iUtils.nameModifier;
      print("halfpath>>>>" + halfpath);
      // File file = File(halfpath);
      if (!Directory("$halfpath").existsSync()) {
        new Directory(halfpath).create();
      }
      String fullPath = halfpath +
          "/" +
          iUtils.nameModifier +
          "_$source\_" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".mp4";

      await downloadFile12(url, fullPath);
      //print("^^^");
    } else {
      await pr!.hide();
      showToast(context, getTranslated(context, "download_error_url"));
    }
  }

  Future downloadFile1(String url, String savePath) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        //print("workin 1");
        await pr!.show();
      }
      Response response =
          await Dio().download(url, savePath).whenComplete(() => () async {
                await pr!.hide();
                showToast(
                    context,
                    getTranslated(context, "download_complete")! +
                        savePath +
                        "\"");
                await pr!.hide();
              });
      await pr!.hide();
      //print("Download Completed");
    } catch (e) {
      await pr!.hide();
      if (Platform.isAndroid || Platform.isIOS) {
        //print("workin 1");
        await pr!.show();
      }
      Response response =
          await Dio().download(url, savePath).whenComplete(() => () async {
                await pr!.hide();
                showToast(
                    context,
                    getTranslated(context, "download_complete")! +
                        savePath +
                        "\"");

                Navigator.of(context).pop(alert);
              });
    }
  }

  showToast(BuildContext? context, var test) {
    final scaffold = ScaffoldMessenger.of(context!);
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

  void downloadSelectedFile(int i) async {
    var imageurl = apiParser!.videos![0].formats![i].url;
    var ext = apiParser!.videos![0].ext;
    if (Platform.isAndroid || Platform.isIOS) {
      //print("workin 2");
      String tempDir = await iUtils.getMyDownloadDirectory();

      String halfpath = tempDir + iUtils.nameModifier;

      // File file = File(halfpath);
      if (!Directory("${halfpath}").existsSync()) {
        Directory(halfpath).create();
      }
      String fullPath = halfpath +
          "/" +
          iUtils.nameModifier +
          "_" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".$ext";
      //print('full path ${fullPath}');

      downloadFile12(imageurl, fullPath);
      // pr!.hide();
    } else {
      //    html.window.open(imageurl, 'Download_Video');
      showToast(context, getTranslated(context, "download_error_platform"));
      // html.AnchorElement anchorElement =
      //     new html.AnchorElement(href: imageurl);
      // anchorElement.download = imageurl;
      // anchorElement.click();
    }
  }

  Widget videoInfoPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(getTranslated(context, "resolution")!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(getTranslated(context, "filesize")!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(getTranslated(context, "download")!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget videoDownloadableList() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            String fileSize =
                (apiParser!.videos![0].formats![i].filesize != null)
                    ? filesize(apiParser!.videos![0].formats![i].filesize)
                    : "NAN";
            //print("apiParser.videos[0].url");
            //print(apiParser.videos[0].url);
            String videoProtoco =
                apiParser!.videos![0].formats![i].protocol.toString();
            //print(videoProtoco);
            return (videoProtoco == 'Protocol.HTTPS' ||
                    videoProtoco == 'Protocol.HTTP' ||
                    videoProtoco == 'https' ||
                    videoProtoco == 'http')
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          apiParser!.videos![0].formats![i].format,
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Text(
                          fileSize,
                          textAlign: TextAlign.center,
                        )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              primary: theme.myAppMainColor),
                          onPressed: () async {
                            downloadSelectedFile(i);
                          },
                          child: Text(
                            getTranslated(context, 'download_text')!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
          itemCount: apiParser!.videos![0].formats!.length,
        ),
      ),
    );
  }

  Widget handleBottomSheet() {
    return showBottomSheetForDownload
        ? SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: DraggableScrollableSheet(
              initialChildSize: 500 / MediaQuery.of(context).size.height,
              minChildSize: 98 / MediaQuery.of(context).size.height,
              maxChildSize: 1,
              builder: (BuildContext context, controller) {
                return _bottomSheet(controller, apiParser!);
              },
            ),
          )
        : Container();
  }

  customListTile({String? number, String? description}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Text(
            number!,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 13,
          ),
          Text(
            description!,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
