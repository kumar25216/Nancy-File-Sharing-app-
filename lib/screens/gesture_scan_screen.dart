import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../controllers/gesture_controller.dart';
import '../services/pairing_manager.dart';
import 'transfer_progress_screen.dart';
import 'dart:io';

class GestureScanScreen extends StatefulWidget {
  final String? incomingPayload;

  const GestureScanScreen({this.incomingPayload});

  @override
  _GestureScanScreenState createState() => _GestureScanScreenState();
}

class _GestureScanScreenState extends State<GestureScanScreen> {
  late VideoPlayerController _controller;
  bool isFileIncoming = false;
  bool hasHandled = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/waiting_receive.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });

    // Wait for widget to build before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gestureController = Provider.of<GestureController>(context, listen: false);

      gestureController.addListener(() {
        if (!hasHandled &&
            gestureController.isFistOpened &&
            widget.incomingPayload != null) {
          final data = PairingManager.parsePayload(widget.incomingPayload!);
          if (data != null) {
            setState(() {
              isFileIncoming = true;
              hasHandled = true;
            });

            Future.delayed(Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => TransferProgressScreen(
                    file: File(data['filePath']),
                  ),
                ),
              );
            });
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

  Widget _buildOverlayText() {
    return Positioned(
      bottom: 80,
      child: Column(
        children: [
          Text(
            "📡 Scanning for sender...",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 18,
              fontFamily: 'monospace',
            ),
          ),
          if (isFileIncoming)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                "Receiving file...",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          _buildOverlayText(),
        ],
      ),
    );
  }
}
