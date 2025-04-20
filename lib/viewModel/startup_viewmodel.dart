import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/db_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import '../models/request_models/refresh_token_request.dart';
import '../models/response_models/refresh_token_response.dart';

class StartupViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  NavigationService get _navigationService => locator<NavigationService>();

  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();

  GlobalService get _globalService => locator<GlobalService>();

  bool checkVersion = true;

  Future doStartupLogic(BuildContext context) async {
    try {
      await loading(true);
      await Future.delayed(const Duration(milliseconds: 100));
      //await _prefService.clear();
      if (!await _prefService.getBool(PrefKey.isLoggedIn)) {
        _navigationService.pushNamedAndRemoveUntil(
          Routes.login,
          args: TransitionType.fade,
        );
      } else {
        String expiresIn = await _prefService.getString(PrefKey.tokenExpiresIn);
        DateTime expiryDateTime = DateTime.parse(expiresIn);
        int remainingSeconds =
            expiryDateTime.difference(DateTime.now()).inSeconds;

        if (remainingSeconds <= 28800) {
          // Less than or equal to 8 hours remaining
          String token = await _prefService.getString(PrefKey.refreshToken);
          var refreshRes = await _apiService.refreshToken(
            RefreshTokenRequest(RefreshToken: token),
          );

          if (refreshRes.errorCode == "PA0004") {
            RefreshTokenResponse response =
                refreshRes.data as RefreshTokenResponse;
            if ((response.accessToken ?? "").isNotEmpty) {
              _prefService.setString(PrefKey.token, response.accessToken ?? "");
              _prefService.setString(
                  PrefKey.refreshToken, response.refreshToken ?? "");

              // Update with new expiry timestamp and current time
              DateTime newExpiryTime = DateTime.now().add(
                Duration(
                    seconds:
                        int.tryParse(response.expiresIn.toString()) ?? 36000),
              );

              _prefService.setString(
                  PrefKey.tokenExpiresIn, newExpiryTime.toString());
              _prefService.setString(
                  PrefKey.tokenStartTime, DateTime.now().toString());
              _gotoNextPage();
            }
          } else {
            await _dialogService.showApiError(
                refreshRes.data.status.toString(),
                refreshRes.data.message.toString(),
                refreshRes.data.error.toString());
            await logout();
            await _navigationService.pushNamedAndRemoveUntil(
              Routes.login,
              args: TransitionType.fade,
            );
          }
        } else {
          _gotoNextPage();
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
    } finally {
      await loading(false);
    }
  }

  Future<bool> logout({bool confirm = true}) async {
    try {
      await loading(true);

      await _prefService.setBool(PrefKey.isLoggedIn, false);

      await _prefService.setString(PrefKey.token, "");
      await _prefService.setString(PrefKey.tokenExpiresIn, "");
      await _prefService.setString(PrefKey.tokenStartTime, "");

      await locator<IHiveService<User>>().deleteAll();

      _navigationService.pushNamedAndRemoveUntil(
        Routes.login,
        args: TransitionType.fade,
      );
    } catch (e, s) {
      _globalService.logError("Error Occured When Logout", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      await loading(false);
    }
    return true;
  }

  void _gotoNextPage() async {
    try {
      User? userResponse =
          await locator<IHiveService<User>>().getFirstOrDefault();

      if (userResponse == null) {
        await logout();
        await _navigationService.pushNamedAndRemoveUntil(
          Routes.login,
          args: TransitionType.fade,
        );
        return;
      }

      switch (userResponse.role) {
        case "Admin":
          {
            _navigationService.pushNamedAndRemoveUntil(
              Routes.admin,
              args: TransitionType.fade,
            );
          }
          break;
        case "Adopter":
          {
            _navigationService.pushNamedAndRemoveUntil(
              Routes.home,
              args: TransitionType.fade,
            );
          }
          break;

        case "Donor":
          {
            _navigationService.pushNamedAndRemoveUntil(
              Routes.petpage,
              args: TransitionType.fade,
            );
          }
          break;
      }
    } catch (e) {
      debugPrint("Error Occured Startup ViewModel ${e.toString()}");
    }
  }
}
