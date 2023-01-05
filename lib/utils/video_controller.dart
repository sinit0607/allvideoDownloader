import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StatusVideo extends StatefulWidget {
  final VideoPlayerController? videoPlayerController;

  StatusVideo({
    @required this.videoPlayerController,
    Key? key,
  }) : super(key: key);

  @override
  _StatusVideoState createState() => new _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: widget.videoPlayerController!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(flickManager: flickManager!),
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController!.dispose();
    flickManager!.dispose();
    super.dispose();
  }
}
