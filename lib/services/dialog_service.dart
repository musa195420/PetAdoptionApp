import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/services/api_service.dart';

import '../custom_widgets/custom_button.dart';
import '../models/message.dart';


class DialogService implements IDialogService {
  IAPIService get _apiService => locator<IAPIService>();
  
  NavigationService get _navigationService => locator<NavigationService>();
  GlobalService get _globalService => locator<GlobalService>();

  TextEditingController amountController = TextEditingController(text: '0.00');
  final GlobalKey _parentKey = GlobalKey();
  OverlayEntry? overlayEntry;
  bool isDot = false;
  int dotCount = 0;
  final List<int> _colors = [
    0xFFFF6F00,
    0xFFBF360C,
    0xFF33691E,
    0xFF004D40,
    0xFF00B8D4,
    0xFF2962FF,
    0xFF6200EA,
    0xFFB71C1C,
    0xFFFF1744,
    0xFFFF6F00,
    0xFFBF360C,
    0xFF33691E,
    0xFF004D40,
    0xFF00B8D4,
    0xFF2962FF,
    0xFF6200EA,
    0xFFB71C1C,
    0xFFFF1744
  ];

 
  @override
  Future<bool> showAlert(Message message) async {
    var isLoader = EasyLoading.isShow ? true : false;
    if (isLoader) {
      await EasyLoading.dismiss();
    }
    var res = await showDialog<bool>(
            context: _navigationService.navigatorKey.currentContext!,
            barrierDismissible: false, // user must tap button!
            builder: (_) => PopScope(
                  canPop: false,
                  child: Dialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Builder(builder: (context) {
                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                        return Padding(
                          padding: const EdgeInsets.all(25),
                          child: SizedBox(
                            width: 600,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text(
                                    message.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(message.description)
                                              ])),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top:10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        CustomButton( height: 40,
                                          text: message.okText,
                                          onTap: () {
                                            _navigationService.popDialog(
                                                result: null);
                                          },
                                          backgroundcolor: Colors.green,
                                          fontcolor: Colors.white,
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                )) ??
        false;
    if (isLoader) {
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
}

abstract class IDialogService {

  Future<bool> showAlert(Message message);
   Future<void> showToast(Message message);

}
