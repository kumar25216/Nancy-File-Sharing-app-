import 'package:flutter/material.dart';
import 'dart:io';
import 'send_animation_screen.dart';

class FileCrunchScreen extends StatefulWidget {
  final File file;

  FileCrunchScreen({required this.file});

  @override
  _FileCrunchScreenState createState() => _FileCrunchScreenState();
}

class _FileCrunchScreenState extends State<FileCrunchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _scaleAnim = Tween<double>(begin: 1.0, end: 0.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => SendAnimationScreen(file: widget.file),
          ));
        }
      });
  }

  void startCrunch() {
    _controller.forward(); // crunch now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: startCrunch,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white12,
                border: Border.all(color: Colors.white30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.white, size: 60),
                  SizedBox(height: 10),
                  Text(widget.file.path.split("/").last,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
