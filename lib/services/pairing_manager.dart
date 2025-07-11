import 'dart:math';
import 'dart:convert';
import 'dart:io';

class PairingManager {
  // Generates a unique 6-character alphanumeric session ID
  static String generateSessionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  // Encodes file and device info into a JSON string (to be sent with gesture)
  static String generatePairingPayload(File file) {
    final payload = {
      'device': Platform.localHostname,
      'fileName': file.path.split('/').last,
      'filePath': file.path,
      'fileSize': "${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB",
      'sessionID': generateSessionID(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    return jsonEncode(payload);
  }

  // Parses incoming JSON string to extract payload
  static Map<String, dynamic>? parsePayload(String data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      print("❌ Payload parse error: $e");
      return null;
    }
  }
}
