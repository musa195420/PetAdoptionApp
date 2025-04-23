// ignore_for_file: non_constant_identifier_names

import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:petadoption/models/api_status.dart";
import "package:petadoption/models/error_models/error_reponse.dart";
import "package:petadoption/models/request_models/add_donor.dart";
import "package:petadoption/models/request_models/animalType_request.dart";
import "package:petadoption/models/request_models/animal_breed.dart";
import "package:petadoption/models/request_models/animal_breed_request.dart";
import "package:petadoption/models/request_models/delete_user.dart";
import "package:petadoption/models/request_models/pet_request.dart";
import "package:petadoption/models/request_models/refresh_token_request.dart";
import "package:petadoption/models/request_models/signup_request.dart";
import "package:petadoption/models/request_models/single_pet.dart";
import "package:petadoption/models/request_models/userinforequest.dart";
import "package:petadoption/models/response_models/user_profile.dart";
import "package:petadoption/services/dialog_service.dart";
import "package:petadoption/services/global_service.dart";
import "package:petadoption/services/http_service.dart";
import "package:petadoption/helpers/locator.dart";

import "../models/hive_models/user.dart";
import "../models/request_models/add_adopter.dart";
import "../models/request_models/login_request.dart";
import "../models/response_models/api_response.dart";
import "../models/response_models/pet_response.dart";
import "../models/response_models/refresh_token_response.dart";

class APIService implements IAPIService {
  HttpService get _httpService => locator<HttpService>();
  GlobalService get _globalService => locator<GlobalService>();
  // ignore: unused_element
  IDialogService get _dialogService => locator<IDialogService>();
  String error = "Not Defined";
  @override
  Future<ApiStatus> refreshToken(RefreshTokenRequest token) async {
    try {
      var response =
          await _httpService.postData("api/users/token", token.toJson());
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
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getProfile(SingleUser user) async {
    try {
      var response =
          await _httpService.postData("api/users/id/profile", user.toJson());
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
            data: UserProfile.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getPetByUserId(SingleUser user) async {
    try {
      var response =
          await _httpService.postData("api/pet/donor/", user.toJson());
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getAnimalType() async {
    try {
      var response = await _httpService.getData("api/animal/");
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getAnimalBreed(GetAnimalBreed breed) async {
    try {
      var response =
          await _httpService.postData("api/breed/animal", breed.toJson());
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getUsers() async {
    try {
      var response = await _httpService.getData("api/users/");
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getAdopters() async {
    try {
      var response = await _httpService.getData("api/adopter/");
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getDonors() async {
    try {
      var response = await _httpService.getData("api/donor/");
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> getPets() async {
    try {
      var response = await _httpService.getData("api/pet/email");
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
            data: res.data,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> addAnimalType(AddAnimalType animal) async {
    try {
      var response =
          await _httpService.postData("api/animal/", animal.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> addAnimalBreed(AddAnimalBreed animal) async {
    try {
      var response = await _httpService.postData("api/breed/", animal.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> login(LoginRequest login) async {
    try {
      var response =
          await _httpService.postData("api/users/login", login.toJson());
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
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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
  Future<ApiStatus> userInfo(UserInfoRequest userInfo) async {
    try {
      var response =
          await _httpService.postData("api/users/email", userInfo.toJson());
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
          return ApiStatus(data: null, errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(data: null, errorCode: res.status.toString());
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



  @override
  Future<ApiStatus> userInfoById(SingleUser userInfo) async {
    try {
      var response =
          await _httpService.postData("api/users/id/", userInfo.toJson());
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
          return ApiStatus(data: null, errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(data: null, errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> updateUser(User user) async {
    try {
      var response = await _httpService.patchData("api/users/", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(data: null, errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(data: null, errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> updateAdopter(UserProfile user) async {
    try {
      var response =
          await _httpService.patchData("api/adopter/", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  
  @override
  Future<ApiStatus> updatePet(PetResponse pet) async {
    try {
      var response =
          await _httpService.patchData("api/pet/update", pet.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> updateDonor(UserProfile user) async {
    try {
      var response = await _httpService.patchData("api/donor/", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        debugPrint(response.statusCode);
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> deleteUser(SingleUser user) async {
    try {
      var response = await _httpService.deleteData("api/users", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> deleteAdopter(SingleUser user) async {
    try {
      var response =
          await _httpService.deleteData("api/adopter", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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


  
  @override
  Future<ApiStatus> deletePet(SinglePet pet) async {
    try {
      var response =
          await _httpService.deleteData("api/pet", pet.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> deleteDonor(SingleUser user) async {
    try {
      var response = await _httpService.deleteData("api/donor/", user.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> signUp(SignupRequest signup) async {
    try {
      var response = await _httpService.postData("api/users/", signup.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? false) {
          return ApiStatus(
            data: User.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()), errorCode: "PA0006");
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

  @override
  Future<ApiStatus> uploadProfileImage(String filePath, String userId) async {
    try {
      final response = await _httpService.uploadImage(
        'api/users/upload-profile',
        {'user_id': userId},
        filePath,
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        return ApiStatus(data: jsonDecode(body), errorCode: "PA0000");
      } else {
        return ApiStatus(
            data: null, errorCode: "PA_UPLOAD_FAIL_${response.statusCode}");
      }
    } catch (e, s) {
      _globalService.logError("Upload Profile Image Error", e.toString(), s);
      return ApiStatus(data: e, errorCode: "PA_UPLOAD_EXCEPTION");
    }
  }

  @override
  Future<ApiStatus> uploadPetImage(String filePath, String petId) async {
    try {
      final response = await _httpService.uploadImage(
        'api/pet/upload-image',
        {'pet_id': petId},
        filePath,
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        return ApiStatus(data: jsonDecode(body), errorCode: "PA0000");
      } else {
        return ApiStatus(
            data: null, errorCode: "PA_UPLOAD_FAIL_${response.statusCode}");
      }
    } catch (e, s) {
      _globalService.logError("Upload Pet Error", e.toString(), s);
      return ApiStatus(data: e, errorCode: "PA_UPLOAD_EXCEPTION");
    }
  }

  @override
  Future<ApiStatus> addPet(PetRequest pet) async {
    try {
      var response = await _httpService.postData("api/pet", pet.toJson());
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
            data: PetRequest.fromJson(res.data),
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()), errorCode: "PA0006");
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

  @override
  Future<ApiStatus> addDonor(AddDonor donor) async {
    try {
      var response = await _httpService.postData("api/donor", donor.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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

  @override
  Future<ApiStatus> addAdopter(AddAdopter adopter) async {
    try {
      var response =
          await _httpService.postData("api/adopter", adopter.toJson());
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
            data: null,
            errorCode: "PA0004",
          );
        } else {
          return ApiStatus(
              data: ErrorResponse.fromJson(res.toJson()),
              errorCode: res.status.toString());
        }
      } else {
        return ApiStatus(
            data: ErrorResponse.fromJson(res.toJson()),
            errorCode: res.status.toString());
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
    Future<ApiStatus> getPets();
  Future<ApiStatus> deletePet(SinglePet pet);
    Future<ApiStatus> updatePet(PetResponse pet);
  Future<ApiStatus> getPetByUserId(SingleUser user);
  Future<ApiStatus> getProfile(SingleUser user);
  Future<ApiStatus> getAdopters();
  Future<ApiStatus> deleteAdopter(SingleUser user);
  Future<ApiStatus> updateAdopter(UserProfile user);
  Future<ApiStatus> getDonors();
  Future<ApiStatus> deleteDonor(SingleUser user);
  Future<ApiStatus> updateDonor(UserProfile user);
  Future<ApiStatus> getUsers();
  Future<ApiStatus> addAdopter(AddAdopter adopter);
  Future<ApiStatus> addDonor(AddDonor donor);
  Future<ApiStatus> addPet(PetRequest pet);
  Future<ApiStatus> addAnimalBreed(AddAnimalBreed animal);
  Future<ApiStatus> addAnimalType(AddAnimalType animal);
  Future<ApiStatus> getAnimalType();
  Future<ApiStatus> getAnimalBreed(GetAnimalBreed breed);
  Future<ApiStatus> uploadProfileImage(String filePath, String userId);
  Future<ApiStatus> signUp(SignupRequest signup);
  Future<ApiStatus> refreshToken(RefreshTokenRequest token);
  Future<ApiStatus> userInfo(UserInfoRequest userInfo);
   Future<ApiStatus> userInfoById(SingleUser userInfo) ;
  Future<ApiStatus> login(LoginRequest login);
  Future<ApiStatus> uploadPetImage(String filePath, String petId);
  Future<ApiStatus> deleteUser(SingleUser user);
  Future<ApiStatus> updateUser(User user);
}
