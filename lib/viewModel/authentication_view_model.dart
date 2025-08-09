// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:petadoption/helpers/error_handler.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/request_models/userinforequest.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';

import '../models/hive_models/user.dart';
import '../models/request_models/login_request.dart';
import '../models/request_models/refresh_token_request.dart';
import '../models/response_models/refresh_token_response.dart';
import '../services/db_service.dart';

class AuthenticationViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  IAPIService get _apiService => locator<IAPIService>();
  NavigationService get _navigationService => locator<NavigationService>();
  GlobalService get _globalService => locator<GlobalService>();
  IDialogService get _dialogService => locator<IDialogService>();

  String? _email = "";
  String? _password = "";

  String? get getEmail => _email;
  String? get getPassword => _password;
  bool showPassword = true;

  void setShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  setEmail(String email) async {
    _email = email;
  }

  setPassword(String password) async {
    _password = password;
  }

  Future<void> _showErrorAndUnfocus(dynamic data) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _dialogService.showApiError(data); // Pass the actual response
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void ForgotPassword(String email, String password) async {
    try {
      await loading(true, loadingText: "Updating Password");
      _globalService.init();
      setEmail(email);
      setPassword(password);
      debugPrint(_apiService.runtimeType.toString());
      var forgRes = await _apiService.resetPassword(LoginRequest(
        email: email,
        password: password,
      ));
      if (forgRes.errorCode == "PA0004") {
        await _dialogService
            .showGlassyErrorDialog("Password updated Successfully");
      } else {
        await _showErrorAndUnfocus(forgRes.data);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    } finally {
      await loading(false);
      notifyListeners();
    }
  }

  String tag = "Authentication view Model";

  gotoLogin() {
    _navigationService.pushReplacementNamed(Routes.login,
        args: TransitionType.slideLeft);
  }

  void Login(String email, String password) async {
    try {
      await loading(true);
      _globalService.init();
      setEmail(email);
      setPassword(password);
      debugPrint(_apiService.runtimeType.toString());
      var loginRes = await _apiService.login(LoginRequest(
        email: email,
        password: password,
      ));
      if (loginRes.errorCode == "PA0004") {
        RefreshTokenResponse response = loginRes.data as RefreshTokenResponse;
        if ((response.accessToken ?? "").isNotEmpty) {
          _prefService.setString(PrefKey.token, response.accessToken ?? "");
          _prefService.setString(
              PrefKey.refreshToken, response.refreshToken ?? "");

          var tokenStartTime = DateTime.now().toString();
          _prefService.setString(PrefKey.tokenStartTime, tokenStartTime);
          _prefService.setString(
              PrefKey.tokenExpiresIn, response.expiresIn.toString());

          var userRes =
              await _apiService.userInfo(UserInfoRequest(email: email));
          if (userRes.errorCode == "PA0004") {
            User userResponse = userRes.data as User;
            await locator<IHiveService<User>>().deleteAllAndAdd(userResponse);
            _globalService.setuser(userResponse);
            _prefService.setBool(PrefKey.isSetupComplete, false);
            _prefService.setBool(PrefKey.isLoggedIn, true);
            setEmail("");
            setPassword("");
            // _globalService.setIsFromLogin(true);
            _globalService.log('Client ($email) Login Success');
            _globalService.setuser(userResponse);
            _gotoNextPage(userResponse);
          } else {
            await _showErrorAndUnfocus(loginRes.data);
            // await _dialogService.showApiError(loginRes.data);

            _globalService.log('Client ($email) Login Fail');
          }
        } else {
          await _showErrorAndUnfocus(loginRes.data);

          _globalService.log('Client ($email) Login Fail');
        }
      } else {
        await _showErrorAndUnfocus(loginRes.data);
        _globalService.log('Client ($email) Login Fail');
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Client ($email) Login", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      await loading(false);
    }
  }

  Future<RefreshTokenResponse?> renewUserToken(User usr) async {
    try {
      var refreshRes = await _apiService.refreshToken(RefreshTokenRequest(
          RefreshToken: await _prefService.getString(PrefKey.refreshToken)));
      if (refreshRes.errorCode == "PA0004") {
        RefreshTokenResponse response = refreshRes.data as RefreshTokenResponse;
        if ((response.accessToken ?? "").isNotEmpty) {
          return response;
        }
      }
      await _dialogService.showApiError(refreshRes.data);
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    }
    return null;
  }

  void gotoSignup() {
    _navigationService.pushNamedAndRemoveUntil(
      Routes.signup,
      args: TransitionType.fade,
    );
  }

  void gotoForgotPassword() {
    _navigationService.pushNamedAndRemoveUntil(
      Routes.forgotpassword,
      args: TransitionType.slideRight,
    );
  }

  void _gotoNextPage(User? userResponse) async {
    try {
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
              Routes.home,
              args: TransitionType.fade,
            );
          }
          break;
      }
    } catch (e) {
      debugPrint("Error Occured Startup ViewModel ${e.toString()}");
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
}
