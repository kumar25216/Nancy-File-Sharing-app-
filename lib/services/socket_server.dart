import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;

class SocketServer {
  ServerSocket? _server;
  final int port;
  final File fileToSend;

  SocketServer({required this.port, required this.fileToSend});

  Future<void> startServer() async {
    try {
      _server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      print('✅ Server started on ${_server!.address.address}:$port');
      _server!.listen(_handleClient);
    } catch (e) {
      print('❌ Failed to start server: $e');
    }
  }

  void _handleClient(Socket client) async {
    print('📥 Client connected: ${client.remoteAddress.address}');

    final fileName = p.basename(fileToSend.path);
    final fileSize = await fileToSend.length();

    // Send header: filename and filesize
    final header = '$fileName|$fileSize\n';
    client.add(header.codeUnits);

    // Wait a moment to sync
    await Future.delayed(Duration(milliseconds: 300));

    // Send file in chunks
    final fileStream = fileToSend.openRead();
    await fileStream.forEach((chunk) {
      client.add(chunk);
    });

    print('✅ File sent: $fileName (${fileSize / (1024 * 1024):.2f} MB)');
    await client.flush();
    await client.close();
  }

  Future<void> stopServer() async {
    await _server?.close();
    print('🛑 Server stopped.');
  }
}
