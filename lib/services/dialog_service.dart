import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/helpers/locator.dart';
import '../custom_widgets/custom_button.dart';
import '../models/error_models/error_reponse.dart';
import '../models/message.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    message = "Please  Contact the administrator. Or Get Back To Us Later!";

    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }

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

    if (EasyLoading.isShow) {
      await EasyLoading.show(status: 'Loading...');
    }

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
      barrierDismissible: false, // prevent closing manually
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).maybePop();
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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
  Future<void> showSuccess({String text = 'Operation Successful'});
  Future<bool> showAlertDialog(Message message);
  Future<int> showSelect(Message message);
  Future<bool> showAlert(Message message);
  Future<bool> showApiError(dynamic error);
  Future<void> showToast(Message message);
}
