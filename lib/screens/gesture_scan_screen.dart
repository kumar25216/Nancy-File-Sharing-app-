import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../controllers/gesture_controller.dart';
import '../services/pairing_manager.dart';

class GestureScanScreen extends StatefulWidget {
  final String? incomingPayload;

  GestureScanScreen({this.incomingPayload});

  @override
  _GestureScanScreenState createState() => _GestureScanScreenState();
}

class _GestureScanScreenState extends State<GestureScanScreen> {
  late VideoPlayerController _controller;
  bool isFileIncoming = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/waiting_receive.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });

    // Listen for fist open after pairing data exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gestureController = Provider.of<GestureController>(context, listen: false);

      gestureController.addListener(() {
        if (gestureController.isFistOpened && widget.incomingPayload != null) {
          final data = PairingManager.parsePayload(widget.incomingPayload!);
          if (data != null) {
            setState(() {
              isFileIncoming = true;
            });

            // TODO: Trigger receive transfer
            print("Receiving: ${data['fileName']}");
            // Navigate or show UI
          } else {
            print("⚠️ Invalid payload. Ignored.");
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          if (isFileIncoming)
            Positioned(
              bottom: 80,
              child: Text(
                "Receiving file...",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
        ],
      ),
    );
  }
}
