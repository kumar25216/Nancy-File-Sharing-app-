import 'package:flutter/material.dart';
import 'file_manager_screen.dart';
import 'gesture_scan_screen.dart';
import '../widgets/futuristic_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🧬 Nancy File Share",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  )),
              SizedBox(height: 60),
              FuturisticButton(
                text: "Send",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FileManagerScreen()));
                },
              ),
              SizedBox(height: 30),
              FuturisticButton(
                text: "Receive",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => GestureScanScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
