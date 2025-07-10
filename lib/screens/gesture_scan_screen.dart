import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GestureScanScreen extends StatefulWidget {
  @override
  _GestureScanScreenState createState() => _GestureScanScreenState();
}

class _GestureScanScreenState extends State<GestureScanScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/waiting_receive.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void simulateReceive() {
    // TODO: trigger receive animation and Wi-Fi connection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
              : CircularProgressIndicator(),
          Positioned(
            bottom: 50,
            child: ElevatedButton(
              onPressed: simulateReceive,
              child: Text("Simulate Fist Open"),
            ),
          )
        ],
      ),
    );
  }
}
