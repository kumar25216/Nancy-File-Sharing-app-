import 'package:flutter/material.dart';

class FuturisticButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const FuturisticButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.cyanAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: color,
          shadowColor: color,
          elevation: 10,
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: color, width: 2),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: color, blurRadius: 8),
            ],
          ),
        ),
      ),
    );
  }
}
