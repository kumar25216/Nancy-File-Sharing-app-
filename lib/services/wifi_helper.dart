import 'dart:io';
import 'dart:async';

class WifiHelper {
  // Simulate file sending process
  static Future<void> sendFile({
    required File file,
    required Function(double) onProgress,
    required Function(double) onSpeed,
    required VoidCallback onComplete,
  }) async {
    int fileSize = file.lengthSync(); // in bytes
    double sent = 0;
    double totalMB = fileSize / (1024 * 1024);
    int tickMs = 300;
    Timer.periodic(Duration(milliseconds: tickMs), (timer) {
      // Simulate sending ~1MB every 300ms
      double sendChunk = (1 + (3 * (sent / totalMB))); // Simulate acceleration
      sent += sendChunk;
      double percent = (sent / totalMB) * 100;

      // Update UI
      onProgress(percent.clamp(0, 100));
      onSpeed((sendChunk * 1000 / tickMs).clamp(0, 100)); // speed in MB/s

      if (percent >= 100) {
        timer.cancel();
        onComplete();
      }
    });
  }
}
