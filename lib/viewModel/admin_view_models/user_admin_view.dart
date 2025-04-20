import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

class UserAdminViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  StartupViewModel get _startModel => locator<StartupViewModel>();
  GlobalService get _globalService => locator<GlobalService>();

  List<User>? users;
  List<User>? filteredUsers;

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
      _globalService.logError("Error Occured When Renew User Token", e.toString(), s);
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
}
