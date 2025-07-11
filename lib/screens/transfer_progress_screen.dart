import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';

class TransferProgressScreen extends StatefulWidget {
  final File file;

  TransferProgressScreen({required this.file});

  @override
  _TransferProgressScreenState createState() => _TransferProgressScreenState();
}

class _TransferProgressScreenState extends State<TransferProgressScreen> {
  double progress = 0.0;
  double speed = 0.0; // in MB/s
  Timer? _timer;

  void startFakeTransfer() {
    const tick = Duration(milliseconds: 300);
    _timer = Timer.periodic(tick, (timer) {
      setState(() {
        double increase = Random().nextDouble() * 5; // simulate 1–5%
        progress += increase;
        speed = increase * 3.2; // simulate MB/s

        if (progress >= 100.0) {
          progress = 100.0;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startFakeTransfer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fileName = widget.file.path.split("/").last;
    int fileSize = widget.file.lengthSync(); // in bytes
    double sizeMB = fileSize / (1024 * 1024);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sending...", style: TextStyle(color: Colors.white70, fontSize: 22)),
            SizedBox(height: 20),
            Text(fileName, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Text("Size: ${sizeMB.toStringAsFixed(2)} MB", style: TextStyle(color: Colors.white54)),
            SizedBox(height: 30),
            CircularProgressIndicator(
              value: progress / 100,
              color: Colors.greenAccent,
              strokeWidth: 6,
            ),
            SizedBox(height: 20),
            Text("Progress: ${progress.toStringAsFixed(1)}%", style: TextStyle(color: Colors.white)),
            Text("Speed: ${speed.toStringAsFixed(2)} MB/s", style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
