import 'dart:convert';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  final channel = const MethodChannel('face_landmarker_channel');
  int _currentCameraIndex = 1;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    channel.setMethodCallHandler((call) async {
      // debugPrint("result callled");
      debugPrint('result ${call.method}');
      if (call.method.compareTo("onResult") == 0) {
        String message = call.arguments;
        debugPrint("result $message");
      } else if (call.method.compareTo("onError") == 0) {
        String message = call.arguments;
        debugPrint("result $message");
      } else if (call.method.compareTo("onNoResult") == 0) {
        String message = call.arguments;
        debugPrint("result $message");
      }
    });

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();

    _controller.startImageStream((image) {
      _sendImageToAndroid(image);
    });

    await _initializeFaceLandmarker();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeFaceLandmarker() async {
    await channel.invokeMethod('initializeFaceLandmarker');
  }

  Future<void> _toggleCamera() async {
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    await _controller.dispose();

    _initializeCamera();
  }

  void _sendImageToAndroid(CameraImage cameraImage) {
    Uint8List? imageData = cameraImageToByteList(cameraImage);

    if (imageData != null) {
      String base64Image = base64Encode(imageData);

      print("${base64Image == null}");

      Map<String, dynamic> imageDataMap = {
        'data': base64Image,
        'width': cameraImage.width,
        'height': cameraImage.height,
      };

      channel.invokeMethod('processImage',
          {'imageData': imageDataMap, 'isFrontFacing': false}).then((result) {
        debugPrint('FaceLandmarkerHelper: $result');
      });
    }
  }

  Uint8List? cameraImageToByteList(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel!;

      // Initialize the output buffer
      final int uvBufferOffset = width * height;
      final Uint8List uvBuffer = Uint8List(uvBufferOffset);

      // Convert YUV420 to RGB888
      ui.decodeImageFromList(Uint8List.fromList(image.planes[0].bytes),
          (ui.Image img) {
        for (int y = 0; y < height; y++) {
          final int uvRowIndex = uvRowStride * (y >> 1);
          final int uvIndex = uvRowIndex + (y & 1) * uvPixelStride;
          for (int x = 0; x < width; x++) {
            final int uvIndexX = uvIndex + (x >> 1) * 2;
            uvBuffer[y * width + x] =
                image.planes[0].bytes[y * width + x] & 0xff |
                    (image.planes[1].bytes[uvIndexX] & 0xff) << 8 |
                    (image.planes[1].bytes[uvIndexX + 1] & 0xff) << 16 |
                    0xff << 24;
          }
        }
      });

      return uvBuffer;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized == true) {
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Center(child: CameraPreview(_controller)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleCamera,
          child: const Icon(Icons.switch_camera),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
