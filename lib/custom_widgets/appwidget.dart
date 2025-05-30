import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppWidget {
  static Widget imageLoad() {
    return const IntrinsicHeight(
      // helps it fit the available vertical space
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ensures it wraps content tightly
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 50.0,
            ),
            SizedBox(height: 10.0),
            Flexible(
              child: Text(
                'Image Not Loaded\nCheck Format or Internet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget loadingIndicator() {
    return const SpinKitPouringHourGlassRefined(
      color: Colors.purple,
      size: 120,
    );
  }

  static Widget getImage({
    required String imageSource,
    required double height,
    required double width,
    BoxFit fit = BoxFit.cover,
  }) {
    if (imageSource.startsWith('http')) {
      // Handle network image
      return Image.network(
        imageSource,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(child: loadingIndicator());
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff8D20DE), width: 2),
            ),
            child: imageLoad(),
          );
        },
      );
    } else if (imageSource.startsWith('data:image')) {
      // Handle Base64 image
      try {
        final Uint8List imageBytes = _decodeBase64(imageSource);
        return Image.memory(
          imageBytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff8D20DE), width: 2),
              ),
              child: imageLoad(),
            );
          },
        );
      } catch (e) {
        // Fallback for invalid base64
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff8D20DE), width: 2),
          ),
          child: imageLoad(),
        );
      }
    } else {
      // Fallback for invalid format
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff8D20DE), width: 2),
        ),
        child: imageLoad(),
      );
    }
  }

  /// Helper method to decode a Base64 string
  static Uint8List _decodeBase64(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }
}
