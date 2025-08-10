import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/models/response_models/user_verification.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

NavigationService get navigationService => locator<NavigationService>();

class UserVerificationViewModel extends BaseViewModel {
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();

  List<UserVerification>? verifications;
  String? cnicpath;
  String? billImage;
  Future<void> getApplications() async {
    try {
      loading(true);
      var userRes = await _apiService.getApplications();

      if (userRes.errorCode == "PA0004") {
        verifications = (userRes.data as List)
            .map((json) =>
                UserVerification.fromJson(json as Map<String, dynamic>))
            .toList();
        // filteredDisability = List.from(disabilities!);

        // for (var d in disabilities!) {
        //   final animal = d.animal;
        //   if (animal != null && !animalSelection.contains(animal)) {
        //     animalSelection.add(animal);
        //   }
        // }
      } else {
        await _dialogService.showApiError(userRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void resetCnicPath() {
    cnicpath = null;
    notifyListeners();
  }

  void resetBillImagePath() {
    billImage = null;
    notifyListeners();
  }

  Future<void> addUserVerification(UserVerification verification) async {
    try {
      loading(true, loadingText: "Submitting Application");
      var addApp = await _apiService.addUserVerification(verification);
      if (addApp.errorCode == "PA0004") {
        verification =
            verification.copyWithModel(addApp.data as UserVerification);
        _uploadImages(verification);
      } else {
        await _dialogService.showApiError(addApp.data);
      }
    } catch (e) {
      loading(false);
    } finally {
      loading(false);
    }
  }

  void _uploadImages(UserVerification verification) async {
    if (cnicpath == null || billImage == null) {
      return;
    }
    _apiService.uploadBillImage(billImage ?? "", verification.userId ?? "");
    _apiService.uploadCnicImage(cnicpath ?? "", verification.userId ?? "");
  }
}
