import 'package:flutter/material.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class AnimatedFileTile extends StatelessWidget {
  final File file;
  final String animationPath;

  AnimatedFileTile({required this.file, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Lottie.asset(
          animationPath,
          width: 50,
          height: 50,
          repeat: true,
        ),
        title: Text(
          file.path.split('/').last,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.send_rounded, color: Colors.greenAccent),
      ),
    );
  }
}
