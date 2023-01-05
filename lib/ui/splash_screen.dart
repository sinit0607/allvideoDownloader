import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:video_downloader/ui/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF0000),
    ));
    super.initState();
    Timer(const Duration(milliseconds: 2800), onTimerDone);
    Timer(const Duration(milliseconds: 1300), onTimer2Done);
  }

  onTimerDone() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  onTimer2Done() {
    isWhite = true;
    setState(() {});
  }

  bool isWhite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Lottie.asset(
                  'assets/lottieAnimationsJson/cloud_annimation.json',
                  fit: BoxFit.cover),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  // color: Colors.green,
                  child: Image.asset('assets/app_icon.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "All Video Downloader",
                  style: TextStyle(
                    color: isWhite ? Colors.black : Colors.white,
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
