import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:petadoption/models/api_status.dart";
import "package:petadoption/models/request_models/refresh_token_request.dart";
import "package:petadoption/models/request_models/userinforequest.dart";
import "package:petadoption/services/global_service.dart";
import "package:petadoption/services/http_service.dart";
import "package:petadoption/services/network_service.dart";
import "package:petadoption/helpers/locator.dart";

import "../models/hive_models/user.dart";
import "../models/request_models/login_request.dart";
import "../models/response_models/api_response.dart";
import "../models/response_models/refresh_token_response.dart";


class APIService implements IAPIService {
  NetworkService get _networkService => locator<NetworkService>();
  HttpService get _httpService => locator<HttpService>();
  GlobalService get _globalService => locator<GlobalService>();

  @override
  Future<ApiStatus> refreshToken(RefreshTokenRequest token) async {
    if (_networkService.isConnected) {
      try {
        var response = await _httpService.postData(
            "api/users/token", token.toJson());
        if (response.statusCode == 404) {
          return ApiStatus(data: null, errorCode: "PA0002");
        }
        if (response.statusCode == 401) {
          return ApiStatus(data: null, errorCode: "PA0001");
        }
        ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          if (res.success ?? false) {
            return ApiStatus(
              data: RefreshTokenResponse.fromJson(res.data),
              errorCode: "PA0004",
            );
          } else {
            return ApiStatus(data: null, errorCode: res.code ?? "PA0007");
          }
        } else {
          return ApiStatus(data: null, errorCode: res.code ?? "PA0002");
        }
      } on HttpException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0013");
      } on FormatException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0007");
      } on TimeoutException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0003");
      } catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0006");
      }
    } else {
      return ApiStatus(data: null, errorCode: "PA0005");
    }
  }

   @override
     Future<ApiStatus>login(LoginRequest login) async{
       try {
        debugPrint("Check1");
        var response = await _httpService.postData(
            "api/users/login", login.toJson());
        if (response.statusCode == 404) {
          return ApiStatus(data: null, errorCode: "PA0002");
        }
        if (response.statusCode == 401) {
          return ApiStatus(data: null, errorCode: "PA0001");
        }
        ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          if (res.success ?? true) {
            return ApiStatus(
              data: RefreshTokenResponse.fromJson(res.data),
              errorCode: "PA0004",
            );
          } else {
            return ApiStatus(data: null, errorCode: res.code ?? "PA0007");
          }
        } else {
          return ApiStatus(data: null, errorCode: res.code ?? "PA0002");
        }
      } on HttpException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0013");
      } on FormatException catch (e, s) {
         debugPrint(e.toString());
        _globalService.logError("Error Occured!", e.toString(), s);
        return ApiStatus(data: e, errorCode: "PA0007");
      } on TimeoutException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0003");
      } catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0006");
      }
   }

    @override
     Future<ApiStatus>  userInfo(UserInfoRequest  userInfo) async{
       try {
        var response = await _httpService.postData(
            "api/users/email", userInfo.toJson());
        if (response.statusCode == 404) {
          return ApiStatus(data: null, errorCode: "PA0002");
        }
        if (response.statusCode == 401) {
          return ApiStatus(data: null, errorCode: "PA0001");
        }
        ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
        if (response.statusCode == 200) {
          if (res.success ?? true) {
            return ApiStatus(
              data: User.fromJson(res.data),
              errorCode: "PA0004",
            );
          } else {
            return ApiStatus(data: null, errorCode: res.code ?? "PA0007");
          }
        } else {
          debugPrint(response.statusCode );
          return ApiStatus(data: null, errorCode: res.code ?? "PA0002");
        }
      } on HttpException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0013");
      } on FormatException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0007");
      } on TimeoutException catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0003");
      } catch (e, s) {
        _globalService.logError("Error Occured!", e.toString(), s);
        debugPrint(e.toString());
        return ApiStatus(data: e, errorCode: "PA0006");
      }
   }
}

abstract class IAPIService {
  Future<ApiStatus> refreshToken(RefreshTokenRequest token);
Future<ApiStatus>  userInfo(UserInfoRequest  userInfo);
  Future<ApiStatus>login(LoginRequest login);
 
}
