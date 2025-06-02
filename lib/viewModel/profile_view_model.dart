import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../models/hive_models/user.dart';
import '../models/request_models/delete_user.dart';
import '../models/response_models/user_profile.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

class ProfileViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
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

  String? path;
  void removeImagePath() {
    path = null;
    notifyListeners();
  }

  Future<void> saveImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    path = pickedFile.path;

    notifyListeners();
  }

  Future<void> updateUserImage() async {
    if (path != null) {
      final status = await _apiService.uploadProfileImage(path!, user!.userId);
      if (status.data != null) {
        debugPrint("Upload success: ${status.data}");
      } else {
        debugPrint("Upload failed: ${status.errorCode}");
      }
    }
  }

  Future<void> updateUser() async {
    try {
      loading(true, loadingText: "Updating User");
      if (path != null) {
        await updateUserImage();
      }

      await updateRel(user!.role ?? "N/A");
      var updateUserRes = await _apiService.updateUser(User(
          userId: user!.userId,
          phoneNumber: phoneController.text.toString(),
          email: user!.email,
          deviceId: user!.deviceId,
          role: user!.role ?? "Adopter"));
      if (updateUserRes.errorCode == "PA0004") {
        debugPrint("User Updated Success Fully");
        loading(false);
      } else {
        await _dialogService.showApiError(updateUserRes.data);
      }

      // ignore: empty_catches
    } catch (e, s) {
      debugPrint("Error ${e.toString()} \n Stack ${s.toString()}");
    } finally {
      loading(
        false,
      );
    }
  }

  Future<void> updateRel(String role) async {
    switch (role.toLowerCase()) {
      case "adopter":
        {
          var res = await _apiService.updateAdopter(UserProfile(
              name: nameController.text,
              location: addressController.text,
              adopterId: user!.userId,
              isActive: false));
          if (res.errorCode == "PA0004") {
            debugPrint("Adopter Updated Success Fully");
            loading(false);
          } else {
            await _dialogService.showApiError(res.data);
          }
        }
      case "donor":
        {
          var res = await _apiService.updateDonor(UserProfile(
              name: nameController.text,
              location: addressController.text,
              donorId: user!.userId,
              isActive: false));
          if (res.errorCode == "PA0004") {
            debugPrint("Donor Updated Success Fully");
            loading(false);
          } else {
            await _dialogService.showApiError(res.data);
          }
        }
    }
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
