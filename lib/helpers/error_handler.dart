import 'package:flutter/material.dart';

Future<void> printError({
  required String tag,
  required String error,
  String? stack,
}) async {
  debugPrint(
    "Occurred From Class = $tag\nError = $error\nStack = ${stack ?? 'No stack trace'}",
  );
}
