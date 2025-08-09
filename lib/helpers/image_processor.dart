import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:petadoption/helpers/animals.dart';
import 'package:petadoption/helpers/error_handler.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

IDialogService get _dialogService => locator<IDialogService>();

class ImageProcessor {
  static const String tag = "ImageProcessor";
  static const int _maxLoadAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 1);
  static const Duration _releaseModeDelay = Duration(milliseconds: 500);

  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  bool _isLoading = false;
  int _loadAttempts = 0;

  final List<Completer<void>> _loadWaiters = [];

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!Platform.isWindows) {
      await _loadModelWithRetry();
    }
  }

  Future<void> _loadModelWithRetry() async {
    if (_isModelLoaded) return;
    if (_isLoading) {
      final completer = Completer<void>();
      _loadWaiters.add(completer);
      await completer.future;
      return;
    }

    _isLoading = true;
    _loadAttempts = 0;

    while (_loadAttempts < _maxLoadAttempts && !_isModelLoaded) {
      _loadAttempts++;
      try {
        // Add small delay for release mode
        if (!kDebugMode) {
          await Future.delayed(_releaseModeDelay);
        }

        await loadModel();
        _isModelLoaded = true;
        //  _dialogService.showBeautifulToast("✅ Model loaded successfully!");
        debugPrint("✅ Model loaded successfully (attempt $_loadAttempts)");

        for (var waiter in _loadWaiters) {
          if (!waiter.isCompleted) waiter.complete();
        }
      } catch (e, s) {
        printError(tag: tag, error: e.toString(), stack: s.toString());
        debugPrint("❌ Model load attempt $_loadAttempts failed: $e");

        if (_loadAttempts < _maxLoadAttempts) {
          await Future.delayed(_retryDelay);
        } else {
          _dialogService.showBeautifulToast(
            "⚠️ Failed to load model after $_maxLoadAttempts attempts",
          );
        }
      }
    }

    _isLoading = false;
    _loadWaiters.clear();
  }

  Future<void> loadModel() async {
    try {
      // Clear any previous interpreter first
      _interpreter?.close();
      _interpreter = null;

      // Load with error handling for asset loading
      final model = await _loadModelAsset();
      _interpreter = Interpreter.fromBuffer(model);

      // Verify the interpreter is usable
      await _verifyInterpreter();
    } catch (e, s) {
      printError(tag: tag, error: e.toString(), stack: s.toString());
      _dialogService.showErrorHandlingDialog(
        "⚠️ Error loading model ${e.toString()} ${s.toString()}",
      );
      rethrow;
    }
  }

  Future<Uint8List> _loadModelAsset() async {
    try {
      return await rootBundle
          .load('assets/models/pet_adoption_classifier.tflite')
          .then((byteData) => byteData.buffer.asUint8List());
    } catch (e, s) {
      printError(
          tag: tag,
          error: "Asset load failed: ${e.toString()}",
          stack: s.toString());
      throw Exception("Failed to load model asset");
    }
  }

  Future<void> _verifyInterpreter() async {
    try {
      // Simple verification - try to get input tensors
      final inputs = _interpreter?.getInputTensors();
      if (inputs == null || inputs.isEmpty) {
        throw Exception("Invalid model - no input tensors");
      } else {
        debugPrint("Model Loaded Successfully ✅ Model loaded successfully ");
      }
    } catch (e, s) {
      printError(
          tag: tag,
          error: "Model verification failed: ${e.toString()}",
          stack: s.toString());
      _interpreter?.close();
      _interpreter = null;
      throw Exception("Model verification failed");
    }
  }

  /// Preprocess image to match model's `uint8` input format
  Future<Uint8List?> _preprocessImage(File imageFile) async {
    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        _dialogService.showBeautifulToast(
          "⚠️ Error decoding image",
        );
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
    } catch (e, s) {
      printError(tag: tag, error: e.toString(), stack: s.toString());
      _dialogService.showBeautifulToast(
        "⚠️ Error processing image",
      );
      debugPrint("❌ Error processing image: $e");
      return null;
    }
  }

  /// Runs inference on the processed image
  Future<List<Map<String, String>>> runModel(File imageFile) async {
    try {
      // Ensure model is loaded
      if (!_isModelLoaded) {
        await _loadModelWithRetry();
        if (!_isModelLoaded) {
          return [];
        }
      }

      // Preprocess the image
      Uint8List? inputImage = await _preprocessImage(imageFile);
      if (inputImage == null) {
        _dialogService.showBeautifulToast(
          "⚠️ Error processing image",
        );
        debugPrint("❌ Error: Preprocessed image is null.");
        return [];
      }

      // Define correct output tensor shape (expected shape: [1, 36])
      var output = List.generate(1, (i) => List.filled(36, 0));

      // Run inference
      _interpreter?.run(inputImage, output);

      List<int> predictions = output[0];

      // Get the top 5 predictions
      List<int> sortedIndices = List.generate(predictions.length, (i) => i)
        ..sort((a, b) => predictions[b].compareTo(predictions[a]));

      List<Map<String, String>> top5 = sortedIndices.take(5).map((index) {
        return {
          "Animal": animalsclassifiers[index],
          "Confidence": "${predictions[index] / 1000}%"
        };
      }).toList();

      StringBuffer result = StringBuffer("🔍 Top 5 Predictions:\n");
      for (var entry in top5) {
        result.write("${entry['Animal']}: ${entry['Confidence']}\n");
      }

      await _dialogService.showSuccess(text: result.toString());

      return top5;
    } catch (e, s) {
      printError(tag: tag, error: e.toString(), stack: s.toString());
      _dialogService.showBeautifulToast(
        "⚠️ Error analyzing image",
      );
      debugPrint("❌ Error running model: $e");
      return [];
    }
  }
}
