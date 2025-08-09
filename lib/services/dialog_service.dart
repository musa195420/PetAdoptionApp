import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/helpers/locator.dart';
import '../custom_widgets/custom_button.dart';
import '../custom_widgets/date_time_part.dart';
import '../models/error_models/error_reponse.dart';
import '../models/message.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

class DialogService implements IDialogService {
  NavigationService get _navigationService => locator<NavigationService>();

  TextEditingController amountController = TextEditingController(text: '0.00');
  OverlayEntry? overlayEntry;
  bool isDot = false;
  int dotCount = 0;

  @override
  Future<bool> showAlertDialog(Message message) async {
    var isLoader = EasyLoading.isShow ? true : false;
    if (isLoader) {
      await EasyLoading.dismiss();
    }

    var res = await showDialog<bool>(
          context: _navigationService.navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (_) => PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFFFAF3E0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(
                              _navigationService.navigatorKey.currentContext!)
                          .size
                          .height *
                      0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title and Image
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                message.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/error.png',
                              height: MediaQuery.of(_navigationService
                                          .navigatorKey.currentContext!)
                                      .size
                                      .height *
                                  0.15,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFBCAAA4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              message.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4E342E),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            spacing: 10,
                            children: [
                              CustomButton(
                                height: 45,
                                text: message.okText,
                                onTap: () {
                                  _navigationService.popDialog(result: true);
                                },
                                backgroundcolor: const Color(0xFFFF6F00),
                                fontcolor: Colors.white,
                              ),
                              CustomButton(
                                height: 45,
                                text: message.cancelText,
                                onTap: () {
                                  _navigationService.popDialog(result: false);
                                },
                                backgroundcolor: const Color(0xFFFF6F00),
                                fontcolor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;

    if (isLoader) {
      await EasyLoading.show(status: 'Loading...');
    }
    return res;
  }

  @override
  Future<bool> showAlert(Message message) async {
    var isLoader = EasyLoading.isShow ? true : false;
    if (isLoader) {
      await EasyLoading.dismiss();
    }

    var res = await showDialog<bool>(
          context: _navigationService.navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (_) => PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFFFAF3E0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(
                              _navigationService.navigatorKey.currentContext!)
                          .size
                          .height *
                      0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title and Image
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                message.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/error.png',
                              height: MediaQuery.of(_navigationService
                                          .navigatorKey.currentContext!)
                                      .size
                                      .height *
                                  0.15,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFBCAAA4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              message.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4E342E),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            height: 45,
                            text: message.okText,
                            onTap: () {
                              _navigationService.popDialog(result: null);
                            },
                            backgroundcolor: const Color(0xFFFF6F00),
                            fontcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;

    if (isLoader) {
      await EasyLoading.show(status: 'Loading...');
    }
    return res;
  }

  @override
  Future<bool> showApiError(dynamic dynamicRes) async {
    String code = "404";
    String error = "An Error Occurred";
    String message =
        "Please  Contact the administrator. Or Get Back To Us Later!";
    ErrorResponse? errorResponse;
    try {
      errorResponse = dynamicRes as ErrorResponse;
    } catch (e) {
      errorResponse = ErrorResponse(
          error: "Server Not Reachable",
          errorCode: "500",
          message:
              "Please  Contact the administrator. Or Get Back To Us Later!");
    }

    error = errorResponse.error ?? "An Unexpected Error Occurred";
    code = errorResponse.errorCode ?? "404";
    message = errorResponse.message ??
        "Please  Contact the administrator. Or Get Back To Us Later!";
    FocusScope.of(_navigationService.navigatorKey.currentContext!).unfocus();
    var res = await showDialog<bool>(
          context: _navigationService.navigatorKey.currentContext!,
          barrierDismissible: true,
          builder: (_) => PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFFFAF3E0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(
                              _navigationService.navigatorKey.currentContext!)
                          .size
                          .height *
                      0.85,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    // Wrap the entire column
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/error.png',
                          height: MediaQuery.of(_navigationService
                                      .navigatorKey.currentContext!)
                                  .size
                                  .height *
                              0.22,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Oops! Something went wrong",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3E2723),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFCCBFB8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Code: $code",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  )),
                              const SizedBox(height: 6),
                              Text("Error: $error",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                  )),
                              const SizedBox(height: 6),
                              Text("Message: $message",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            height: 45,
                            text: "Got It",
                            onTap: () {
                              _navigationService.popDialog(result: null);
                            },
                            backgroundcolor: const Color(0xFFFF6F00),
                            fontcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;

    return res;
  }

  @override
  Future<void> showToast(Message message) async {
    ScaffoldMessenger.of(_navigationService.navigatorKey.currentContext!)
        .showSnackBar(SnackBar(
            content: Text(
      message.description,
      style: const TextStyle(fontSize: 14),
    )));
  }

  @override
  Future<int> showSelect(Message message) async {
    var isLoader = EasyLoading.isShow ? true : false;
    if (isLoader) {
      await EasyLoading.dismiss();
    }

    var res = await showBarModalBottomSheet<int>(
          context: _navigationService.navigatorKey.currentContext!,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 600,
              child: SingleChildScrollView(
                // Prevent overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap:
                          true, // Ensures ListView takes only required space
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevent ListView scrolling inside SingleChildScrollView
                      itemCount: message.items!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(message.items![index]!),
                          onTap: () {
                            _navigationService.popDialog(result: index);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) ??
        -1;

    if (isLoader) {
      await EasyLoading.show(status: 'Loading...');
    }

    return res;
  }

  @override
  Future<void> showSuccess({String text = 'Operation Successful'}) async {
    showDialog(
      context: _navigationService.navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Auto-close after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular Icon Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.shade100,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.info_outline,
                    size: 50,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown.shade600,
                  ),
                ),

                const SizedBox(height: 16),

                // Thin Divider
                Divider(
                  color: Colors.brown.shade200,
                  thickness: 1,
                ),

                // Closing Text
                Text(
                  "This will close automatically.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown.shade400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Returns `null` if the user cancels either picker.
  Future<DateTime?> showDateTimePicker({
    DateTime? initialDateTime,
    bool barrierDismissible = false,
  }) async {
    // Wrap everything in the same nice‑looking Dialog shell you use elsewhere
    return await showDialog<DateTime?>(
      context: _navigationService.navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (_) => PopScope(
        canPop: barrierDismissible,
        child: DateTimePickerDialog(
          initialDateTime: initialDateTime ?? DateTime.now(),
        ),
      ),
    ); // If nothing came back, treat as cancelled
  }

  @override
  void showBeautifulToast(String message) {
    final context = _navigationService.navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.brown.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 6,
      ),
    );
  }

  @override
  Future<void> showErrorHandlingDialog(String errorMessage) async {
    final context = _navigationService.navigatorKey.currentContext!;
    await showDialog(
      context: context,
      barrierDismissible: false, // Can't close by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Error",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 20,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.brown),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.copy, color: Colors.brown),
              label: const Text(
                "Copy",
                style:
                    TextStyle(color: Colors.brown, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Copied to clipboard!"),
                    backgroundColor: Colors.brown.shade700,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<void> showGlassyErrorDialog(String errorText) async {
    final context = _navigationService.navigatorKey.currentContext!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Auto dismiss after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          backgroundColor:
              Colors.brown.shade50, // very light brown / off-white background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.brown.shade100, // light brown container
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.shade300.withOpacity(0.5),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.brown.shade400),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.brown.shade700, // dark brown circle
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.shade900.withOpacity(0.7),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.pets, // paw/animal icon from Material Icons
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900, // dark brown text
                    shadows: [
                      Shadow(
                        color: Colors.brown.shade200.withOpacity(0.6),
                        offset: const Offset(1, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

abstract class IDialogService {
  void showBeautifulToast(String message);
  Future<void> showSuccess({String text = 'Operation Successful'});
  Future<bool> showAlertDialog(Message message);
  Future<int> showSelect(Message message);
  Future<bool> showAlert(Message message);
  Future<bool> showApiError(dynamic error);
  Future<void> showToast(Message message);
  Future<DateTime?> showDateTimePicker({
    DateTime? initialDateTime,
    bool barrierDismissible = false,
  });
  Future<void> showErrorHandlingDialog(String errorMessage);
  Future<void> showGlassyErrorDialog(String errorText);
}
