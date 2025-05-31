import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../models/hive_models/user.dart';
import '../models/request_models/delete_user.dart';
import '../models/request_models/userinforequest.dart';
import '../models/response_models/user_profile.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

class ProfileViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();

  PetResponse? pet;
  User? user;

  UserProfile? userProfile;

  // Editing state
  bool editMode = false;
  void seteditMode(bool editMode) {
    this.editMode = editMode;
    notifyListeners();
  }

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  void goBack() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.home,
        args: TransitionType.slideLeft);
  }

  void getUser() async {
    try {
      String? userId = _globalService.getuser()!.userId;
      userProfile = null;
      loading(true, loadingText: "Checking Links");

      var userRes = await _apiService.userInfoById(SingleUser(userId: userId));
      if (userRes.errorCode == "PA0004") {
        user = userRes.data as User;
      } else {
        return;
      }

      var profileRes = await _apiService.getProfile(SingleUser(userId: userId));

      if (profileRes.errorCode == "PA0004") {
        userProfile = profileRes.data as UserProfile;
        // Pre-fill text fields
        nameController.text = userProfile?.name ?? '';
        phoneController.text = user?.phoneNumber ?? '';
        addressController.text = userProfile?.location ?? '';
      }
    } catch (e) {
      loading(false);
    } finally {
      if (user != null) {
        notifyListeners();
      }
      loading(false);
    }
  }

  void logout() async {
    await _startupViewModel.logout();
  }

  void toggleEditMode() {
    editMode = !editMode;
    notifyListeners();
  }

  Future<void> updateProfile() async {}
}
