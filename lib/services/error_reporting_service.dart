import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/api_status.dart';
import 'package:petadoption/models/error_info.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';

import '../models/message.dart';

class ErrorReportingService implements IErrorReportingService {
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();

  List<ErrorInfo> _errors = [];
  List<ErrorInfo> get errors => _errors;
  setErrors(List<ErrorInfo> errors) async {
    _errors = errors;
  }

  @override
  Future<void> initErrors() async {
    try {
      var response =
          await rootBundle.loadString('assets/json/errorReport.json');
      Iterable l = json.decode(response);
      setErrors(List<ErrorInfo>.from(l.map((x) => ErrorInfo.fromJson(x))));
    } catch (e,s) {
      _globalService.logError("Error Occured!", e.toString(), s);
      debugPrint(e.toString());
    }
  }

  @override
  Future<ErrorInfo?> getError(ApiStatus apiStatus) async {
    try {
      if (_errors.isEmpty) {
        await initErrors();
      }
      return _errors
          .firstWhere((element) => element.errorCode == apiStatus.errorCode);
    } catch (e,s) {
      _globalService.logError("Error Occured!", e.toString(), s);
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<void> showError(ApiStatus apiStatus) async {
    try {
      if (_errors.isEmpty) {
        await initErrors();
      }

      var error = _errors
          .where((element) => element.errorCode == apiStatus.errorCode)
          .firstOrNull;
      if (error != null) {
        await _dialogService.showAlert(Message(
            title: error.shortError,
            description: "${error.detail}"" \nError Code : ""${error.errorCode}"));
      } else {
        await _dialogService.showAlert(Message(
            title: "Alert!",
            description:
                "Unable to Connect to the server, Please contact to administrator.\nError Code : ${apiStatus.errorCode}"));
      }
      if(apiStatus.errorCode=="PA0001"){
        // await locator<HomeViewModel>().logout(confirm: false);
      }
    } catch (e,s) {
      _globalService.logError("Error Occured!", e.toString(), s);
      debugPrint(e.toString());
    }
  }
}

abstract class IErrorReportingService {
  Future<void> initErrors();
  Future<ErrorInfo?> getError(ApiStatus apiStatus);
  Future<void> showError(ApiStatus apiStatus);
}
