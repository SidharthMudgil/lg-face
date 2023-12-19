import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lg_face/service/face_landmarker_service.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  late int _currentCameraIndex;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    _currentCameraIndex = 0;
    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();

    FaceLandmarkerService faceLandmarkerService = FaceLandmarkerService();
    await faceLandmarkerService.loadModel();
    _controller.startImageStream((image) => {
      faceLandmarkerService.inference(cameraImage: image)
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    await _controller.dispose();

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
    );

    await _controller.initialize();

    if (mounted) {
      setState(() {});
    }
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
