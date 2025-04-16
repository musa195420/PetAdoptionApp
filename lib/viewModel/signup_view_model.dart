// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:custom_platform_device_id/platform_device_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/request_models/userinforequest.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/error_reporting_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';

import '../models/api_status.dart';
import '../models/hive_models/user.dart';
import '../models/request_models/login_request.dart';
import '../models/request_models/refresh_token_request.dart';
import '../models/response_models/login_response.dart';
import '../models/response_models/refresh_token_response.dart';
import '../services/db_service.dart';


class SignupViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  IAPIService get _apiService => locator<IAPIService>();
   IErrorReportingService get _errorReportingService =>
      locator<IErrorReportingService>();
  NavigationService get _navigationService => locator<NavigationService>();
  GlobalService get _globalService => locator<GlobalService>();
  IDialogService get _dialogService => locator<IDialogService>();
   String deviceId="23423sadasd3q432423";
  final LocalAuthentication _auth = LocalAuthentication();

  String? _email = "";
  String? _password = "";
  bool _showPassword = false;

  String role="Adopter";
  
  String? get getEmail => _email;
  String? get getPassword => _password;
  bool get getShowPassword => _showPassword;
 
Future<void> _deviceId() async
{
 deviceId= await PlatformDeviceId.getDeviceId??"defaultId";
}
  setShowPassword(bool showPassword) async {
    _showPassword = showPassword;
    notifyListeners();
  }

  setEmail(String email) async {
    _email = email;
  }

  setPassword(String password) async {
    _password = password;
  }

  void Signup(String email, String password,String phoneNumber) async {
    try {
      await _deviceId();
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
       RefreshTokenResponse response = loginRes.data as  RefreshTokenResponse;
        if ((response.accessToken ?? "").isNotEmpty) {
          _prefService.setString(PrefKey.token, response.accessToken ?? "");
          _prefService.setString(
              PrefKey.refreshToken, response.refreshToken??"" );
         
         var tokenStartTime = DateTime.now().toString();
          _prefService.setString(PrefKey.tokenStartTime, tokenStartTime);
           _prefService.setString(PrefKey.tokenExpiresIn, response.expiresIn.toString());

          var userRes = await _apiService.userInfo(UserInfoRequest(
              
              email: email));
          if (userRes.errorCode == "PA0004") {
            User userResponse = userRes.data as User;
            await locator<IHiveService<User>>().deleteAllAndAdd(userResponse);
        
              _prefService.setBool(PrefKey.isSetupComplete, false);
              _prefService.setBool(PrefKey.isLoggedIn, true);
              setEmail("");
              setPassword("");
              // _globalService.setIsFromLogin(true);
              _globalService.log('Client ($email) Login Success');
    
              _navigationService.pushNamedAndRemoveUntil(
                Routes.startup,
                args: TransitionType.fade,
              );
            
          } else {
            await _errorReportingService.showError(userRes);
            _globalService.log('Client ($email) Login Fail');
          }
        } else {
          await _errorReportingService
              .showError(ApiStatus(errorCode: "PA0018"));
          _globalService.log('Client ($email) Login Fail');
        }
      } else {
        await _errorReportingService.showError(loginRes);
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
      var refreshRes = await _apiService
          .refreshToken(RefreshTokenRequest(RefreshToken:await  _prefService.getString(PrefKey.refreshToken)));
      if (refreshRes.errorCode == "PA0004") {
        RefreshTokenResponse response = refreshRes.data as RefreshTokenResponse;
        if ((response.accessToken ?? "").isNotEmpty) {
          return response;
        }
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    }
    return null;
  }
  
  void gotoLogin() {
      _navigationService.pushNamedAndRemoveUntil(
                Routes.login,
                args: TransitionType.fade,
              );
  }

  void setRole(String Role) {
     role=Role;
     notifyListeners();
  }
}
