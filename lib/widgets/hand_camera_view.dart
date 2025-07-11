import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_hand_detection/google_mlkit_hand_detection.dart';
import 'package:provider/provider.dart';
import '../controllers/gesture_controller.dart';

class HandCameraView extends StatefulWidget {
  @override
  _HandCameraViewState createState() => _HandCameraViewState();
}

class _HandCameraViewState extends State<HandCameraView> {
  late CameraController _cameraController;
  late final HandDetector _handDetector;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _handDetector = HandDetector(
      options: HandDetectorOptions(),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();
    _cameraController.startImageStream(_processCameraImage);
    setState(() {});
  }

  void _processCameraImage(CameraImage image) async {
    if (isDetecting) return;
    isDetecting = true;

    try {
      final inputImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        inputImageData: InputImageData(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          imageRotation: InputImageRotation.rotation0deg,
          inputImageFormat: InputImageFormat.nv21,
          planeData: image.planes.map(
            (plane) => InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            ),
          ).toList(),
        ),
      );

      final hands = await _handDetector.processImage(inputImage);

      final gesture = Provider.of<GestureController>(context, listen: false);
      if (hands.isNotEmpty) {
        final hand = hands.first;

        // Analyze hand position
        final landmarks = hand.landmarks;
        final thumbTip = landmarks[HandLandmarkType.thumbTip];
        final indexTip = landmarks[HandLandmarkType.indexTip];

        final distance = (thumbTip.x - indexTip.x).abs();

        if (distance < 0.05) {
          // Fist closed
          gesture.detectFistClosed();
        } else {
          // Hand open
          gesture.detectFistOpened();
        }
      }
    } catch (e) {
      print("Hand detection error: $e");
    }

    isDetecting = false;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _handDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _cameraController.value.isInitialized
        ? CameraPreview(_cameraController)
        : Center(child: CircularProgressIndicator());
  }
}
