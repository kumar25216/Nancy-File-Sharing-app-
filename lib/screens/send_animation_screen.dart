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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 0.1, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Wait briefly then go to progress screen
          Future.delayed(Duration(milliseconds: 600), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TransferProgressScreen(file: widget.file),
              ),
            );
          });
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get fileName => widget.file.path.split("/").last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent.withOpacity(0.1), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.send_rounded, color: Colors.greenAccent, size: 60),
                SizedBox(height: 10),
                Text(
                  fileName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Preparing to send...",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 8),
                CircularProgressIndicator(
                  color: Colors.greenAccent,
                  strokeWidth: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
