import 'package:flutter/material.dart';
import 'dart:io';
import 'transfer_progress_screen.dart';

class SendAnimationScreen extends StatefulWidget {
  final File file;

  SendAnimationScreen({required this.file});

  @override
  _SendAnimationScreenState createState() => _SendAnimationScreenState();
}

class _SendAnimationScreenState extends State<SendAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _scaleAnim = Tween<double>(begin: 0.1, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => TransferProgressScreen(file: widget.file)));
        }
      });

    _controller.forward(); // file expands and flies
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.2),
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.send_rounded, color: Colors.greenAccent, size: 60),
                SizedBox(height: 10),
                Text(widget.file.path.split("/").last,
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
