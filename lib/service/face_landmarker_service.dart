import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

import '../core/util/image_utils.dart';

class FaceLandmarkerService {
  final outputShapes = [];
  final outputTypes = [];

  late Interpreter interpreter;
  late int address;
  Map<String, dynamic>? inferenceResults;

  Future<void> loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter = await Interpreter.fromAsset(
        "assets/face_landmark.tflite",
        options: interpreterOptions,
      );

      address = interpreter.address;

      final outputTensors = interpreter.getOutputTensors();

      for (var tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      debugPrint('Error while creating interpreter: $e');
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(192, 192, ResizeMethod.bilinear))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  Map<String, dynamic>? predict(image_lib.Image image) {
    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image, -90);
      image = image_lib.flipHorizontal(image);
    }

    final tensorImage = TensorImage.fromImage(image);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[1]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputScores.buffer,
    };

    interpreter.runForMultipleInputs(inputs, outputs);

    if (outputScores.getDoubleValue(0) < 0) {
      return null;
    }

    final landmarkPoints = outputLandmarks.getDoubleList().reshape([468, 3]);
    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / 192 * image.width,
        point[1] / 192 * image.height,
      ));
    }

    return {'point': landmarkResults};
  }

  Future<void> inference({
    required CameraImage cameraImage,
  }) async {
    await loadModel();
    Map<String, dynamic> map = {
      'cameraImage': cameraImage,
      'detectorAddress': address,
    };

    final result = await compute(runFaceLandmarker, map);

    inferenceResults = result;

    debugPrint("${result ?? 'sad'}");
  }

  Future<Map<String, dynamic>?> runFaceLandmarker(Map<String, dynamic> params) async {
    final faceLandmarker = FaceLandmarkerService();
    final image = ImageUtils.convertCameraImage(params['cameraImage']);
    final result = faceLandmarker.predict(image!);
    return result;
  }
}
