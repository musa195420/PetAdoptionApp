// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/signup_request.dart';
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
import 'package:intl/intl.dart';

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
  List<String> roles = ["Adopter", "Donor", "Admin"];
  
  String role="Adopter";
  
  String? get getEmail => _email;
  String? get getPassword => _password;
  bool get getShowPassword => _showPassword;


//   bool? _serviceEnabled;
// PermissionStatus? _permissionGranted;
// LocationData? _locationData;


//  Future<void> _getLocation()async
//  {
//   try{
// Location location = new Location();



// _serviceEnabled = await location.serviceEnabled();
// if (_serviceEnabled!=null && !_serviceEnabled!) {
//   _serviceEnabled = await location.requestService();
//   if (!_serviceEnabled!) {
//     return;
//   }
// }

// _permissionGranted = await location.hasPermission();
// if (_permissionGranted == PermissionStatus.denied) {
//   _permissionGranted = await location.requestPermission();
//   if (_permissionGranted != PermissionStatus.granted) {
//     return;
//   }
// }

// _locationData = await location.getLocation();
//   }catch(e,s)
//   {
//  debugPrint("Error ${e.toString()} Stack ${s.toString()}");
//   }
//  }
// Future<void> _deviceId() async {
//   try {
//     deviceId = await PlatformDeviceId.getDeviceId ?? "";
//   } catch(e) {
//     // Generate random hex string
//     final random = Random();
//     final hex = List.generate(6, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();

//     // Get current date-time in a compact format
//     final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

//     // Assign fallback device ID
//     deviceId = 'RND_${hex}_$now';
//   }
// }
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
      //await _deviceId();
     
      await loading(true);
      _globalService.init();
      setEmail(email);
      setPassword(password);
      debugPrint(_apiService.runtimeType.toString());
      var signupRes = await _apiService.signUp(SignupRequest(
          email: email,
          password: password, phoneNumber: phoneNumber, role: role, deviceId: deviceId,
          ));
      if (signupRes.errorCode == "PA0004") { 
         var loginRes = await _apiService.login(LoginRequest(
          email: email,
          password: password,
          ));

       if(loginRes.errorCode == "PA0004"){
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
           await  _globalService.setuser(userResponse);
        
              _prefService.setBool(PrefKey.isSetupComplete, false);
              _prefService.setBool(PrefKey.isLoggedIn, true);
              setEmail("");
              setPassword("");
              // _globalService.setIsFromLogin(true);
              _globalService.log('Client ($email) Login Success');
    
             _gotoNextPage();
            
          } else {
            await _errorReportingService.showError(userRes);
            _globalService.log('Client ($email) Login Fail');
          }
        } else{
          await _errorReportingService
              .showError(ApiStatus(errorCode: "PA0018"));
          _globalService.log('Client ($email) Login Fail');
        }
       }
       else{
         _navigationService.pushNamedAndRemoveUntil(
                Routes.login,
                args: TransitionType.fade,
              );
       }
      } else{
      await _dialogService.showApiError( signupRes.data.status.toString(),signupRes.data.message.toString(), signupRes.data.error.toString());
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
      else{
           await _dialogService.showApiError( refreshRes.data.status.toString(),refreshRes.data.message.toString(), refreshRes.data.error.toString());
   
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
  
   _gotoNextPage()async {

switch(role)
{
  case "Adopter":
  await    _navigationService.pushNamedAndRemoveUntil(
                Routes.home,
                args: TransitionType.fade,
              );
  
  break;
  case "Donor":
  await   _navigationService.pushNamedAndRemoveUntil(
                Routes.petpage,
                args: TransitionType.fade,
              );
  
  break;
  case "Admin":
   await  _navigationService.pushNamedAndRemoveUntil(
                Routes.admin,
                args: TransitionType.fade,
              );
  
  break;
}
  
  }
}
