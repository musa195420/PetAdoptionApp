import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:petadoption/helpers/animals.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

class ImageProcessor {
  Interpreter? _interpreter;

  ImageProcessor() {
    _loadModel();
  }

  /// Loads the TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/models/pet_adoption_classifier.tflite');
      debugPrint("✅ TFLite model loaded successfully!");
    } catch (e) {
      debugPrint("❌ Failed to load model: $e");
    }
  }

  /// Preprocess image to match model's `uint8` input format
  Future<Uint8List?> _preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        debugPrint("❌ Error decoding image.");
        return null;
      }

      // Resize image to 224x224
      img.Image resizedImage =
          img.copyResize(decodedImage, width: 224, height: 224);

      // Convert image to uint8 format (1D List)
      Uint8List inputImage = Uint8List(224 * 224 * 3);
      int index = 0;

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          int pixel = resizedImage.getPixel(x, y);
          inputImage[index++] = img.getRed(pixel); // Red (0-255)
          inputImage[index++] = img.getGreen(pixel); // Green (0-255)
          inputImage[index++] = img.getBlue(pixel); // Blue (0-255)
        }
      }

      return inputImage;
    } catch (e) {
      debugPrint("❌ Error processing image: $e");
      return null;
    }
  }

  /// Runs inference on the processed image
  Future<List<Map<String, String>>> runModel(File imageFile) async {
    try {
      if (_interpreter == null) {
        await _loadModel();
      }
      // Preprocess the image
      Uint8List? inputImage = await _preprocessImage(imageFile);
      if (inputImage == null) {
        debugPrint("❌ Error: Preprocessed image is null.");
        return [];
      }

      // Define correct output tensor shape (expected shape: [1, 36])
      var output = List.generate(1, (i) => List.filled(36, 0));

      // Run inference
      _interpreter?.run(inputImage, output);

      List<int> predictions = output[0];

      // Animal list (ensure it is defined)

      // Get the top 5 predictions
      List<int> sortedIndices = List.generate(predictions.length, (i) => i)
        ..sort((a, b) => predictions[b].compareTo(predictions[a]));

      List<Map<String, String>> top5 = sortedIndices.take(5).map((index) {
        return {
          "Animal": animalsclassifiers[index],
          "Confidence": "${predictions[index] / 1000}%"
        };
      }).toList();

      debugPrint("🔍 Top 5 Predictions:");
      for (var entry in top5) {
        debugPrint("${entry['Animal']}: ${entry['Confidence']}");
      }

      return top5;
    } catch (e) {
      debugPrint("❌ Error running model: $e");
      return [];
    }
  }
}
