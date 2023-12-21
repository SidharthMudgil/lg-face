import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:lg_face/core/utils/image_utils.dart';

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
    // print("format: ${cameraImage.format.group.name}");
    //
    // final image = ImageUtils.convertYUV420ToImage(cameraImage);
    // List<int> pngBytes = imglib.encodeJpg(image);
    // String base64String = base64Encode(Uint8List.fromList(pngBytes));
    XFile photo = await _controller.takePicture();
    List<int> photoAsBytes = await photo.readAsBytes();
    String base64String = base64Encode(photoAsBytes);
    print('base64Image + $base64String');

    Map<String, dynamic> imageDataMap = {
      'data': base64String,
      'width': cameraImage.width,
      'height': cameraImage.height,
    };
  _controller.stopImageStream();
    // channel.invokeMethod('processImage',
    //     {'imageData': imageDataMap, 'isFrontFacing': false}).then((result) {
    //   debugPrint('FaceLandmarkerHelper: $result');
    // });
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
