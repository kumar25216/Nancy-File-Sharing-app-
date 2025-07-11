import 'dart:io';
import 'package:flutter/material.dart';

class CrunchingFileTile extends StatefulWidget {
  final File file;
  final VoidCallback onCrunchComplete;

  const CrunchingFileTile({
    required this.file,
    required this.onCrunchComplete,
  });

  @override
  _CrunchingFileTileState createState() => _CrunchingFileTileState();
}

class _CrunchingFileTileState extends State<CrunchingFileTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _liftAnim;
  late Animation<Color?> _glowColor;

  bool _crunched = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _scaleAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );

    _liftAnim = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _glowColor = ColorTween(begin: Colors.transparent, end: Colors.greenAccent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCrunchComplete();
        setState(() => _crunched = true);
      }
    });

    // Auto-play when loaded
    Future.delayed(Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get fileName => widget.file.path.split("/").last;

  @override
  Widget build(BuildContext context) {
    if (_crunched) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _liftAnim.value),
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _glowColor.value ?? Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: _glowColor.value?.withOpacity(0.6) ?? Colors.transparent,
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.white70),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fileName,
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
