import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class NearbyConnectionService extends ChangeNotifier {
  final nearbyService = NearbyService();
  List<Device> connectedDevices = [];

  Future<void> init() async {
    await nearbyService.init(
      serviceType: 'nancyshare',
      deviceName: Platform.localHostname,
      strategy: Strategy.P2P_STAR,
      callback: (isRunning) {
        debugPrint("NearbyService is running: $isRunning");
      },
    );

    nearbyService.stateChangedSubscription(callback: (devicesList) {
      connectedDevices = devicesList.where((d) => d.state == SessionState.connected).toList();
      notifyListeners();
    });

    nearbyService.dataReceivedSubscription(callback: (data) {
      print("Received Data: $data");
      // TODO: Handle received file data here
    });

    await nearbyService.startBrowsingForPeers();
    await nearbyService.startAdvertisingPeer();
  }

  void sendFile(File file) async {
    final bytes = await file.readAsBytes();
    for (final device in connectedDevices) {
      await nearbyService.sendBytesPayload(device.deviceId, bytes);
    }
  }

  void stopAll() {
    nearbyService.stopAdvertisingPeer();
    nearbyService.stopBrowsingForPeers();
    nearbyService.disconnectPeer(deviceID: connectedDevices.first.deviceId);
  }
}
