import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
      debugPrint('${call.method} ${call.arguments}');
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

  void _sendImageToAndroid(CameraImage cameraImage) async {
    final imageDataMap = yuvTransform(cameraImage);
    channel.invokeMethod('processImage',
        {'imageData': imageDataMap, 'isFrontFacing': false}).then((result) {
      debugPrint('FaceLandmarkerHelper: $result');
    });
  }

  Map<String, dynamic> yuvTransform(CameraImage image, {int? quality = 60}) {
    List<int> strides = Int32List(image.planes.length * 2);
    int index = 0;

    List<Uint8List> data = image.planes.map((plane) {
      strides[index] = (plane.bytesPerRow);
      index++;
      strides[index] = (plane.bytesPerPixel)!;
      index++;
      return plane.bytes;
    }).toList();

    final map = {
      'platforms': data,
      'height': image.height,
      'width': image.width,
      'strides': strides,
      'quality': quality
    };

    return map;
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
