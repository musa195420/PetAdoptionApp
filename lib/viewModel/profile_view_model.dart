import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/admin_modals/pet_edit_modal.dart';

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

  List<PetResponse>? pet;
  User? user;

  UserProfile? userProfile;

  // Editing state
  bool editMode = false;
  void seteditMode(bool editMode) {
    this.editMode = editMode;
    notifyListeners();
  }

  // Controllers

  void goBack() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.home,
        args: TransitionType.slideLeft);
  }

  Color getColor(String isApproved) {
    switch (isApproved) {
      case "Approved":
        return Colors.green;

      case "Pending":
        return Colors.grey;

      case "Rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
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

  Future<void> updateUser(String phone, String location, String name) async {
    try {
      loading(true, loadingText: "Updating User");
      if (path != null) {
        await updateUserImage();
      }

      await updateRel(user!.role ?? "N/A", name, location);
      var updateUserRes = await _apiService.updateUser(User(
          userId: user!.userId,
          phoneNumber: phone,
          email: user!.email,
          deviceId: user!.deviceId,
          role: user!.role ?? "Adopter"));
      if (updateUserRes.errorCode == "PA0004") {
        debugPrint("User Updated SuccessFully");
        loading(false);
      } else {
        await _dialogService.showGlassyErrorDialog(updateUserRes.data);
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

  Future<void> updateRel(String role, String name, String address) async {
    switch (role.toLowerCase()) {
      case "adopter":
        {
          var res = await _apiService.updateAdopter(UserProfile(
              name: name,
              location: address,
              adopterId: user!.userId,
              isActive: false));
          if (res.errorCode == "PA0004") {
            debugPrint("Adopter Updated Success Fully");
            loading(false);
          } else {
            await _dialogService.showGlassyErrorDialog(res.data);
          }
        }
      case "donor":
        {
          var res = await _apiService.updateDonor(UserProfile(
              name: name,
              location: address,
              donorId: user!.userId,
              isActive: false));
          if (res.errorCode == "PA0004") {
            debugPrint("Donor Updated Success Fully");
            loading(false);
          } else {
            await _dialogService.showGlassyErrorDialog(res.data);
          }
        }
    }
  }

  Future<UserProfile?> getUser() async {
    try {
      String? userId = _globalService.getuser()!.userId;
      userProfile = null;
      loading(true, loadingText: "Checking Links");

      var userRes = await _apiService.userInfoById(SingleUser(userId: userId));

      if (userRes.errorCode == "PA0004") {
        user = userRes.data as User;
      } else {
        return null;
      }

      var profileRes = await _apiService.getProfile(SingleUser(userId: userId));

      if (profileRes.errorCode == "PA0004") {
        userProfile = profileRes.data as UserProfile;
        userProfile?.phonenumber = user?.phoneNumber ?? "";
        if (user!.role.toString().toLowerCase() == "donor") {
          await getPet(userId);
        }
        // Pre-fill text fields

        return userProfile;
      }
    } catch (e) {
      loading(false);
    } finally {
      if (user != null) {
        notifyListeners();
      }
      loading(false);
    }
    return null;
  }

  Future<void> getPet(String userId) async {
    var resPet = await _apiService.getPetByUserId(SingleUser(userId: userId));
    if (resPet.errorCode == "PA0004") {
      try {
        pet = (resPet.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        debugPrint(pet!.first.name.toString());
      } catch (e) {
        debugPrint("Error ${e.toString()}");
      }
    } else {
      return;
    }
  }

  void logout() async {
    await _startupViewModel.logout();
  }

  void toggleEditMode() {
    editMode = !editMode;
    notifyListeners();
  }

  gotopetDetail(PetResponse pet) async {
    await _navigationService.pushModalBottom(Routes.pet_edit_modal,
        data: PetEditModal(pet: pet));
  }
}
