import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lg_face/core/constant/constants.dart';
import 'package:lg_face/presentation/help/help_screen.dart';
import 'package:lg_face/service/lg_service.dart';

import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  final channel = const MethodChannel('face_landmarker_channel');
  int _currentCameraIndex = 1;
  String gesture = "Neutral";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();

    channel.setMethodCallHandler((call) async {
      _performGestureCommands(call);
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

  Map<String, double> _getBlendshapeMap(String input) {
    Map<String, double> blendshapes = {};
    final keyValPair = input
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll("data: ", "")
        .split(", ");

    for (String pair in keyValPair) {
      List<String> tokens = pair.split('=');
      if (tokens.length == 2) {
        blendshapes[tokens[0]] = double.tryParse(tokens[1]) ?? 0.0;
      }
    }

    return blendshapes;
  }

  void _performGestureCommands(MethodCall call) async {
    final connected = await LGService.isConnected();

    if (call.method == "onResult") {
      final blendshapes = _getBlendshapeMap(call.arguments.toString());

      final blendshapeValues = {
        "neutral": blendshapes['neutral'] ?? 0.0,
        'mouthRollUpper': blendshapes['mouthRollUpper'] ?? 0.0,
        'mouthRollLower': blendshapes['mouthRollLower'] ?? 0.0,
        'eyeBlinkLeft': blendshapes['eyeBlinkLeft'] ?? 0.0,
        'eyeBlinkRight': blendshapes['eyeBlinkRight'] ?? 0.0,
        'browInnerUp': blendshapes['browInnerUp'] ?? 0.0,
        'jawOpen': blendshapes['jawOpen'] ?? 0.0,
      };

      String max = 'neutral';

      blendshapeValues.forEach((key, value) {
        if (value > blendshapeValues[max]!) {
          max = key;
        }
      });

      if (blendshapes[max]! < 0.4) {
        max = 'neutral';
      }

      setState(() {
        gesture = max;
      });

      if (LGService.instance == null || !connected) {
        return;
      }

      switch (max) {
        case 'mouthRollLower':
          LGService.instance?.performCommand(LGState.south);
          break;
        case 'mouthRollUpper':
          LGService.instance?.performCommand(LGState.north);
          break;
        case 'eyeBlinkLeft':
          LGService.instance?.performCommand(LGState.east);
          break;
        case 'eyeBlinkRight':
          LGService.instance?.performCommand(LGState.west);
          break;
        case 'browInnerUp':
          LGService.instance?.performCommand(LGState.zoomIn);
          break;
        case 'jawOpen':
          LGService.instance?.performCommand(LGState.zoomOut);
          break;
        default:
          LGService.instance?.performCommand(LGState.idle);
          break;
      }
    } else {
      LGService.instance?.performCommand(LGState.idle);
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
        {'imageData': imageDataMap, 'isFrontFacing': false}).then((result) {});
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("LG Face"),
        actions: [
          IconButton(
            onPressed: _toggleCamera,
            icon: const Icon(Icons.switch_camera_outlined),
          ),
          IconButton(
            onPressed: () {
              _controller.stopImageStream();
              Navigator.of(context).pushReplacementNamed(HelpScreen.route);
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
          IconButton(
            onPressed: () {
              _controller.stopImageStream();
              Navigator.of(context).pushReplacementNamed(SettingsScreen.route);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;
    if (_controller.value.isInitialized == true) {
      final scale = _controller.value.aspectRatio / size.aspectRatio;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CameraPreview(_controller),
          Text(
            "Gesture Detected: $gesture",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.lightBlue,
            ),
          ),
        ],
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
