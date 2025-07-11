import 'dart:math';
import 'dart:convert';
import 'dart:io';

class PairingManager {
  static String generateSessionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static String generatePairingPayload(File file) {
    final payload = {
      'device': Platform.localHostname,
      'fileName': file.path.split('/').last,
      'fileSize': "${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB",
      'sessionID': generateSessionID(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    return jsonEncode(payload);
  }

  static Map<String, dynamic>? parsePayload(String data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return null;
    }
  }
}
