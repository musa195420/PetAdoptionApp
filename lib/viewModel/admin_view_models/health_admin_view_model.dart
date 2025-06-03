// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';

import '../../models/health_info.dart';
import '../../models/response_models/health_info.dart';
import '../../views/modals/admin_modals/health_info_modal.dart';

class HealthAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  List<PetHealthInfo>? healthInfo;
  List<PetHealthInfo>? filteredInfo;

  Future<void> gethealthInfo() async {
    try {
      loading(true);
      var secureRes = await _apiService.getHealth();

      if (secureRes.errorCode == "PA0004") {
        healthInfo = (secureRes.data as List)
            .map((json) => PetHealthInfo.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredInfo = List.from(healthInfo!);
      } else {
        await _dialogService.showApiError(secureRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterHealths(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredInfo = List.from(healthInfo ?? []);
    } else {
      filteredInfo = healthInfo
          ?.where(
              (u) => u.petName!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredInfo = List.from(healthInfo ?? []);
    notifyListeners();
  }

  Future<void> deleteHealth(String healthId, String petId) async {
    try {
      loading(true, loadingText: "Deleting SecureMeetup");
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really want to delete SecureMeetup ?"));
      if (res) {
        var resDelete = await _apiService
            .deleteHealth(PetHealthInfo(healthId: healthId, petId: petId));
        if (resDelete.errorCode == "PA0004") {
          debugPrint("SecureMeetup Deleted Sucess Fully");
        } else {
          await _dialogService.showApiError(resDelete.data);
        }
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      loading(false);
    }
  }

  void updateHealth(String petId, String vaccinationId, String diseaseId,
      String disabilityId) async {
    try {
      loading(true, loadingText: "Secure Meetup Updating ...");

      var updateRes = await _apiService.updateHealth(HealthInfoModel(
        petId: petId,
        vaccinationId: vaccinationId,
        diseaseId: diseaseId,
        disabilityId: disabilityId,
      ));

      if (updateRes.errorCode == "PA0004") {
        debugPrint("Secure Updated Success Fully");

        await gethealthInfo();
        _dialogService.showSuccess(text: "Secure Updated Success Fully");
      } else {
        await _dialogService.showApiError(updateRes.data);
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  void gotoPrevious() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.admin,
        args: TransitionType.slideLeft);
  }

  Future<void> gotoEdithealth(PetHealthInfo health) async {
    try {
      await _navigationService.pushModalBottom(Routes.health_modal,
          data: HealthInfoModal(
            info: health,
          ));
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }
}
