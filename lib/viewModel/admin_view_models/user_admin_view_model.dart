import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/delete_user.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/userlink_modal.dart';

import '../../views/modals/user_edit_modal.dart';

class UserAdminViewModel extends BaseViewModel {
  // ignore: unused_element
  PrefService get _prefService => locator<PrefService>();
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  // ignore: unused_element
  StartupViewModel get _startModel => locator<StartupViewModel>();
  GlobalService get _globalService => locator<GlobalService>();
  String? path;
  List<User>? users;
  List<User>? filteredUsers;

  List<String> roles = ["Adopter", "Donor", "Admin"];
  String role = "Adopter";
  void setRole(String role) {
    this.role = role;
    notifyListeners();
  }

  void removeImagePath() {
    path = null;
    notifyListeners();
  }

  Future<void> updateUserImage(String userId) async {
    if (path != null) {
      final status = await _apiService.uploadProfileImage(path!, userId);
      if (status.data != null) {
        debugPrint("Upload success: ${status.data}");
      } else {
        debugPrint("Upload failed: ${status.errorCode}");
      }
    }
  }

  Future<void> savePetImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    path = pickedFile.path;

    notifyListeners();
  }

  Future<void> getUsers() async {
    try {
      loading(true);
      var usersRes = await _apiService.getUsers();

      if (usersRes.errorCode == "PA0004") {
        users = (usersRes.data as List)
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredUsers = List.from(users!);
      } else {
        await _dialogService.showApiError(
          usersRes.data.status.toString(),
          usersRes.data.message.toString(),
          usersRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterUsers(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredUsers = List.from(users ?? []);
    } else {
      filteredUsers = users
          ?.where((u) => u.email.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredUsers = List.from(users ?? []);
    notifyListeners();
  }

  IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.security;
      case 'adopter':
        return Icons.favorite;
      case 'donor':
        return Icons.volunteer_activism;
      default:
        return Icons.help_outline;
    }
  }

  void gotoEditUser(User user) async {
    path = null;
    await _navigationService.pushModalBottom(Routes.user_edit_modal,
        data: UserEditModal(user: user));
  }

  Future<void> deleteUser(String userId) async {
    try {
      loading(true, loadingText: "Deleting User");
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really want to delete User ?"));
      if (res) {
        var resDelete =
            await _apiService.deleteUser(SingleUser(userId: userId));
        if (resDelete.errorCode == "PA0004") {
          debugPrint("User Deleted Sucess Fully");
        } else {
          await _dialogService.showApiError(
              resDelete.data.status.toString(),
              resDelete.data.message.toString(),
              resDelete.data.error.toString());
        }
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      loading(false);
    }
  }

  void updateUser(String email, String number, User user) async {
    try {
      loading(true);
      var updateUserRes = await _apiService.updateUser(User(
          userId: user.userId,
          email: email,
          phoneNumber: number,
          role: role,
          deviceId: user.deviceId,
          password: user.password));

      if (updateUserRes.errorCode == "PA0004") {
        debugPrint("User Updated Success Fully");
        loading(false);
        if (path != null) {
          _updateImage(user.userId, path!);
        }
      } else {
        await _dialogService.showApiError(
            updateUserRes.data.status.toString(),
            updateUserRes.data.message.toString(),
            updateUserRes.data.error.toString());
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  void _updateImage(String userId, String path) async {
    try {
      loading(true, loadingText: "Uploading Image");
      var imageRes = await _apiService.uploadProfileImage(path, userId);
      if (imageRes.errorCode == "PA0000") {
        debugPrint("User Updated Success Fully");
      } else {
        await _dialogService
            .showAlert(Message(description: "Failed To update Image"));
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  UserProfile? userProfile;

  void showLink(String userId,
      {bool isAdmin = false, String role = "Adopter"}) async {
    User? user;
    try {
      userProfile = null;
      pets = null;
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
        if (role.toLowerCase() == "donor" || isAdmin) {
          await _getpetuserId(userId);
        }
      }
    } catch (e) {
      loading(false);
    } finally {
      if (user != null) {
        await _navigationService.pushModalBottom(Routes.user_link_modal,
            data: UserLinkModal(
              user: user,
              pets: pets,
              userProfile: userProfile,
            ));
      }
      loading(false);
    }
  }

  List<PetResponse>? pets;
  Future<void> _getpetuserId(String userId) async {
    var petRes = await _apiService.getPetByUserId(SingleUser(userId: userId));

    if (petRes.errorCode == "PA0004") {
      debugPrint(petRes.data.toString());

      // Parse the response
      pets = (petRes.data as List)
          .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
          .toList();

      // Get all names for the dialog
    }
  }

  void gotoPrevious() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.admin,
        args: TransitionType.slideLeft);
  }
}
