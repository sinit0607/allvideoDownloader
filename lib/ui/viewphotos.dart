import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:video_downloader/localization/language_constants.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

import '../main.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;

  const ViewPhotos(this.imgPath);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  var filePath;
  final String imgShare = "Image.file(File(widget.imgPath),)";
  late BuildContext buildContextM;

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onLoading(bool t, String str) {
    if (!t) {
      print("working 1");
      buildContextM = context;
      Navigator.pop(buildContextM);
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            getTranslated(
                                buildContextM, 'videwphoteospage_greate')!,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(
                              getTranslated(buildContextM,
                                  'videwphoteospage_filemanger')!,
                              style: TextStyle(
                                  fontSize: 16.0, color: theme.myAppMainColor)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: MaterialButton(
                              child: Text(getTranslated(
                                  buildContextM, 'videwphoteospage_close')!),
                              color: theme.myAppMainColor,
                              textColor: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: new FloatingActionButton(
            backgroundColor: theme.myAppMainColor,
            child: Icon(Icons.save),
            onPressed: () async {
              _onLoading(true, "");

              Uri myUri = Uri.parse(widget.imgPath);
              File originalImageFile = File.fromUri(myUri);
              Uint8List? bytes;
              await originalImageFile.readAsBytes().then((value) {
                bytes = Uint8List.fromList(value);
                print('reading of bytes is completed12');
              }).catchError((onError) {
                print('Exception Error while reading audio from path:' +
                    onError.toString());
              });
              final result =
                  await ImageGallerySaver.saveImage(Uint8List.fromList(bytes!));
              print(result);
              _onLoading(
                  false, getTranslated(context, 'videwphoteospage_ifimage')!);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
