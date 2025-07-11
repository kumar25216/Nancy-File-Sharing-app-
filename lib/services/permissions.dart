import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await [
    Permission.storage,
    Permission.location,
    Permission.nearbyWifiDevices,
  ].request();
}
