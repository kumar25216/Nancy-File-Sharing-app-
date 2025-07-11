import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class TransferProgressScreen extends StatefulWidget {
  final File file;

  const TransferProgressScreen({required this.file});

  @override
  _TransferProgressScreenState createState() => _TransferProgressScreenState();
}

class _TransferProgressScreenState extends State<TransferProgressScreen> {
  double progress = 0.0;
  late Timer _timer;
  late String fileName;
  late String fileSize;

  @override
  void initState() {
    super.initState();
    fileName = widget.file.path.split("/").last;
    fileSize = _formatBytes(widget.file.lengthSync());

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.02;
        if (progress >= 1.0) {
          progress = 1.0;
          _timer.cancel();
        }
      });
    });
  }

  String _formatBytes(int bytes) {
    final mb = bytes / (1024 * 1024);
    if (mb > 1024) {
      return (mb / 1024).toStringAsFixed(2) + ' GB';
    } else {
      return mb.toStringAsFixed(2) + ' MB';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final speed = (Random().nextDouble() * 800 + 200).toStringAsFixed(2); // Simulate speed

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyanAccent),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.file_present_rounded, color: Colors.cyanAccent, size: 60),
              SizedBox(height: 12),
              Text(fileName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  )),
              Text(fileSize,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  )),
              SizedBox(height: 24),
              LinearProgressIndicator(
                value: progress,
                color: Colors.cyanAccent,
                backgroundColor: Colors.white12,
                minHeight: 8,
              ),
              SizedBox(height: 16),
              Text(
                "${(progress * 100).toInt()}% transferred",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
              ),
              Text(
                "$speed Mbps",
                style: TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
              SizedBox(height: 24),
              if (progress >= 1.0)
                Text(
                  "✅ Transfer Completed",
                  style: TextStyle(color: Colors.lightGreenAccent, fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
