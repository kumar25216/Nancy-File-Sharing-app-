import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class SocketClient {
  final String serverIP;
  final int serverPort;

  SocketClient({required this.serverIP, required this.serverPort});

  Future<void> connectAndReceiveFile() async {
    try {
      final socket = await Socket.connect(serverIP, serverPort, timeout: Duration(seconds: 10));
      print('📡 Connected to server: $serverIP:$serverPort');

      final completer = Completer<void>();
      final receivedBytes = <int>[];

      String? fileName;
      int fileSize = 0;
      bool headerParsed = false;
      int totalReceived = 0;

      socket.listen((data) async {
        if (!headerParsed) {
          final headerData = utf8.decode(data);
          final parts = headerData.split('\n').first.trim().split('|');
          if (parts.length == 2) {
            fileName = parts[0];
            fileSize = int.tryParse(parts[1]) ?? 0;
            headerParsed = true;
            print('📁 Receiving: $fileName ($fileSize bytes)');
          }
        } else {
          receivedBytes.addAll(data);
          totalReceived += data.length;

          // Optional: Show progress in console
          final percent = ((totalReceived / fileSize) * 100).clamp(0, 100).toStringAsFixed(1);
          print('⏳ Downloading... $percent%');

          if (totalReceived >= fileSize) {
            final dir = await getExternalStorageDirectory();
            final file = File('${dir!.path}/$fileName');
            await file.writeAsBytes(receivedBytes);
            print('✅ File saved to: ${file.path}');
            socket.destroy();
            completer.complete();
          }
        }
      }, onError: (err) {
        print("❌ Socket error: $err");
        socket.destroy();
        completer.completeError(err);
      }, onDone: () {
        print("🔌 Disconnected from server.");
      });

      await completer.future;
    } catch (e) {
      print("❌ Connection failed: $e");
    }
  }
}
