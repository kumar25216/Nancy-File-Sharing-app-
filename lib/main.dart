import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/gesture_controller.dart';
import 'screens/home_screen.dart';
import 'services/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Ask for storage/location permissions
  runApp(NancyFileShare());
}

class NancyFileShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GestureController(),
      child: MaterialApp(
        title: 'Nancy File Share',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(backgroundColor: Colors.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
