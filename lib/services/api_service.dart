// ignore_for_file: non_constant_identifier_names

import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:petadoption/models/api_status.dart";
import "package:petadoption/models/error_models/error_reponse.dart";
import "package:petadoption/models/health_info.dart";
import "package:petadoption/models/request_models/add_donor.dart";
import "package:petadoption/models/request_models/animalType_request.dart";
import "package:petadoption/models/request_models/animal_breed.dart";
import "package:petadoption/models/request_models/animal_breed_request.dart";
import "package:petadoption/models/request_models/application_model.dart";
import "package:petadoption/models/request_models/delete_user.dart";
import "package:petadoption/models/request_models/favourite.dart";
import "package:petadoption/models/request_models/pet_request.dart";
import "package:petadoption/models/request_models/proof_image.dart";
import "package:petadoption/models/request_models/refresh_token_request.dart";
import "package:petadoption/models/request_models/signup_request.dart";
import "package:petadoption/models/request_models/single_disease.dart";
import "package:petadoption/models/request_models/single_pet.dart";
import "package:petadoption/models/request_models/update_animal.dart";
import "package:petadoption/models/request_models/userinforequest.dart";
import "package:petadoption/models/response_models/breed_type.dart";
import "package:petadoption/models/response_models/health_info.dart";
import "package:petadoption/models/response_models/meetup_verification.dart";
import "package:petadoption/models/response_models/payment.dart";
import "package:petadoption/models/response_models/payment_intent_model.dart";
import "package:petadoption/models/response_models/user_profile.dart";
import "package:petadoption/models/response_models/user_verification.dart";
import "package:petadoption/services/dialog_service.dart";
import "package:petadoption/services/global_service.dart";
import "package:petadoption/services/http_service.dart";
import "package:petadoption/helpers/locator.dart";
import "package:petadoption/viewModel/authentication_view_model.dart";

import "../models/hive_models/user.dart";
import "../models/request_models/add_adopter.dart";
import "../models/request_models/add_bulk.dart";
import "../models/request_models/login_request.dart";
import "../models/request_models/message_model.dart";
import "../models/request_models/receiver_model.dart";
import "../models/request_models/single_disability.dart";
import "../models/request_models/single_vaccine.dart";
import "../models/request_models/update_breed.dart";
import "../models/response_models/api_response.dart";
import "../models/response_models/get_disability.dart";
import "../models/response_models/get_disease.dart";
import "../models/response_models/get_vaccines.dart";
import "../models/response_models/meetup.dart";
import "../models/response_models/message_info.dart";
import "../models/response_models/pet_response.dart";
import "../models/response_models/refresh_token_response.dart";
import "../models/response_models/secure_meetup.dart";

AuthenticationViewModel get _authModel => locator<AuthenticationViewModel>();

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
  Future<ApiStatus> getPetById(SinglePet pet) async {
    try {
      var response = await _httpService.postData("api/pet/id/", pet.toJson());
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
            data: PetResponse.fromJson(res.data),
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
  Future<ApiStatus> getMessagesBetweenUsers(MessageModel message) async {
    try {
      var response =
          await _httpService.postData("api/message/between/", message.toJson());
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
  Future<ApiStatus> getHealthById(PetHealthInfo health) async {
    try {
      var response =
          await _httpService.postData("api/health/id", health.toJson());
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
            data: PetHealthInfo.fromJson(res.data),
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
  Future<ApiStatus> getHealthByPetId(SinglePet pet) async {
    try {
      var response =
          await _httpService.postData("api/health/pet", pet.toJson());
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
            data: PetHealthInfo.fromJson(res.data.first),
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
  Future<ApiStatus> getAnimalBreed(GetAnimal breed) async {
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
  Future<ApiStatus> getAnimalBreeds() async {
    try {
      var response = await _httpService.getData("api/breed/");
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
  Future<ApiStatus> getVaccines() async {
    try {
      var response = await _httpService.getData("api/vaccination");
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
  Future<ApiStatus> getAnimalVaccineById(GetAnimal breed) async {
    try {
      var response =
          await _httpService.postData("api/vaccination/animal", breed.toJson());
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
  Future<ApiStatus> getDiseases() async {
    try {
      var response = await _httpService.getData("api/disease");
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
  Future<ApiStatus> getAnimalDiseaseById(GetAnimal disease) async {
    try {
      var response =
          await _httpService.postData("api/disease/animal", disease.toJson());
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
  Future<ApiStatus> getDisability() async {
    try {
      var response = await _httpService.getData("api/disability");
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
  Future<ApiStatus> getAnimalDisabilityById(GetAnimal disablility) async {
    try {
      var response = await _httpService.postData(
          "api/disability/animal/", disablility.toJson());
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
  Future<ApiStatus> getMeetups() async {
    try {
      var response = await _httpService.getData("api/meetup");
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
  Future<ApiStatus> getPayments() async {
    try {
      var response = await _httpService.getData("api/payment/");
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
  Future<ApiStatus> getApplications() async {
    try {
      var response = await _httpService.getData("api/application");
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
  Future<ApiStatus> getMeetupVerifications() async {
    try {
      var response = await _httpService.getData("api/verification-meetups");
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
  Future<ApiStatus> getUserVerifications() async {
    try {
      var response = await _httpService.getData("api/verification-users/");
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
  Future<ApiStatus> getMeetupsById(Meetup meetup) async {
    try {
      // "meetup_id": "c8978f0b-4402-4e8a-a67b-1429063d19b7"
      var response =
          await _httpService.postData("api/meetup/id/", meetup.toJson());
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
            data: Meetup.fromJson(res.data),
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
  Future<ApiStatus> getMeetupsByUserId(Meetup meetup) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response =
          await _httpService.postData("api/meetup/user/", meetup.toJson());
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
  Future<ApiStatus> getMeetupsBetweenUserId(Meetup meetup) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/meetup/between-users", meetup.toJson());
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
            data: Meetup.fromJson(res.data),
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
  Future<ApiStatus> getMeetupVerificationById(MeetupVerification meetup) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/verification-meetups/id", meetup.toJson());
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
            data: MeetupVerification.fromJson(res.data),
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
  Future<ApiStatus> getUserVerificationByUserId(UserVerification user) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/verification-users/id", user.toJson());
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
            data: UserVerification.fromJson(res.data),
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
  Future<ApiStatus> getUserVerificationById(UserVerification user) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/verification-users/verif-id", user.toJson());
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
            data: UserVerification.fromJson(res.data),
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
  Future<ApiStatus> getUserPaymentByUserId(Payment payment) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response =
          await _httpService.postData("api/payment/user", payment.toJson());
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
            data: Payment.fromJson(res.data),
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
  Future<ApiStatus> getUserPaymentByPaymentId(Payment payment) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response =
          await _httpService.postData("api/payment/id", payment.toJson());
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
            data: Payment.fromJson(res.data),
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
  Future<ApiStatus> getUserApplicationBYUserId(
      ApplicationModel application) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/application/user", application.toJson());
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
            data: ApplicationModel.fromJson(res.data),
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
  Future<ApiStatus> getUserApplicationBYId(ApplicationModel application) async {
    try {
      // "user_id": "2a517e5e-4106-4c15-94c9-5123012e5a9f"
      var response = await _httpService.postData(
          "api/application/id", application.toJson());
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
            data: ApplicationModel.fromJson(res.data),
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
  Future<ApiStatus> getMeetupsByPetId(Meetup meetup) async {
    try {
      // "pet_id": "6f0a1296-ac3d-4909-8cc1-0036e342102f"
      var response =
          await _httpService.postData("api/meetup/pet", meetup.toJson());
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
            data: Meetup.fromJson(res.data),
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
    } on SocketException catch (e, s) {
      _globalService.logError("Error Occured!", e.toString(), s);
      _authModel.logout(confirm: true);
      debugPrint(e.toString());
      return ApiStatus(data: e, errorCode: "PA0007");
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
  Future<ApiStatus> getPetsByAnimalId(PetResponse pet) async {
    try {
      var response =
          await _httpService.postData("api/pet/animal", pet.toJson());
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
  Future<ApiStatus> getPetsByBreedId(PetResponse pet) async {
    try {
      var response = await _httpService.postData("api/pet/breed", pet.toJson());
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
  Future<ApiStatus> getFavourite(Favourite favourite) async {
    try {
      var response = await _httpService.postData(
          "api/favourite/user/", favourite.toJson());
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
    } on SocketException catch (e, s) {
      _globalService.logError("Error Occured!", e.toString(), s);
      _authModel.logout(confirm: true);
      debugPrint(e.toString());
      return ApiStatus(data: e, errorCode: "PA0007");
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
  Future<ApiStatus> getMessages(MessageInfo message) async {
    try {
      var response =
          await _httpService.postData("api/message/info", message.toJson());
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
  Future<ApiStatus> getHealth() async {
    try {
      var response = await _httpService.getData("api/health/");
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
  Future<ApiStatus> getSecureMeetups() async {
    try {
      var response = await _httpService.getData("api/secureMeetup/");
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
  Future<ApiStatus> getSecureMeetupsByMeetupID(SecureMeetup meetup) async {
    try {
      var response = await _httpService.postData(
          "api/secureMeetup/meetup", meetup.toJson());
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
            data: SecureMeetup.fromJson(res.data),
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
  Future<ApiStatus> addAnimalTypeBulk(AddAnimalType animal) async {
    try {
      var response =
          await _httpService.postData("api/animal/bulk", animal.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
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
  Future<ApiStatus> addAnimalBreedBulk(AddAnimalBreed animal) async {
    try {
      var response =
          await _httpService.postData("api/breed/bulk", animal.toJson());
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
  Future<ApiStatus> addVaccineBulk(AddInBulk vaccines) async {
    try {
      var response = await _httpService.postData(
          "api/vaccination/bulk", vaccines.toJson());
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
  Future<ApiStatus> addDiseasesBulk(AddInBulk diseases) async {
    try {
      var response = await _httpService.postData(
          "api/disease/bulk", diseases.toJsonDiseases());
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
  Future<ApiStatus> addDisabilityBulk(AddInBulk disability) async {
    try {
      var response = await _httpService.postData(
          "api/disability/bulk", disability.toJsonDiability());
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
  Future<ApiStatus> getUserinfo(SingleUser user) async {
    try {
      var response =
          await _httpService.postData("api/users/full/", user.toJson());
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
            data: ReceiverModel.fromJson(res.data),
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
  Future<ApiStatus> updateVaccine(Vaccine vaccine) async {
    try {
      var response =
          await _httpService.patchData("api/vaccination", vaccine.toJson());
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
  Future<ApiStatus> updateDisease(Disease disease) async {
    try {
      var response =
          await _httpService.patchData("api/disease", disease.toJson());
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
  Future<ApiStatus> updateDisability(Disability disability) async {
    try {
      var response =
          await _httpService.patchData("api/disability", disability.toJson());
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
  Future<ApiStatus> updateMeetup(Meetup meetup) async {
    try {
      var response =
          await _httpService.patchData("api/meetup", meetup.toJson());
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
  Future<ApiStatus> updateMeetupVerification(MeetupVerification meetup) async {
    try {
      var response = await _httpService.patchData(
          "api/verification-meetups", meetup.toJson());
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
  Future<ApiStatus> updateUserVerification(UserVerification user) async {
    try {
      var response = await _httpService.patchData(
          "api/verification-users/update", user.toJson());
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
  Future<ApiStatus> updateApplication(ApplicationModel application) async {
    try {
      var response = await _httpService.patchData(
          "api/application/update", application.toJson());
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
  Future<ApiStatus> updateMessages(MessageModel message) async {
    try {
      var response =
          await _httpService.patchData("api/message", message.toJson());
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
  Future<ApiStatus> updateHealth(HealthInfoModel health) async {
    try {
      var response =
          await _httpService.patchData("api/health", health.toJson());
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
  Future<ApiStatus> updateAnimalType(UpdateAnimal animal) async {
    try {
      var response =
          await _httpService.patchData("api/animal/", animal.toJson());
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
  Future<ApiStatus> updateBreed(UpdateBreed breed) async {
    try {
      var response = await _httpService.patchData("api/breed/", breed.toJson());
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
  Future<ApiStatus> updateSecureMeetup(SecureMeetup secure) async {
    try {
      var response =
          await _httpService.patchData("api/secureMeetup", secure.toJson());
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
  Future<ApiStatus> addSecureMeetup(SecureMeetup secure) async {
    try {
      var response =
          await _httpService.postData("api/secureMeetup/", secure.toJson());
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
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
  Future<ApiStatus> deleteAnimalType(GetAnimal animal) async {
    try {
      var response =
          await _httpService.deleteData("api/animal", animal.toJson());
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
  Future<ApiStatus> deleteAnimalBreed(BreedType breed) async {
    try {
      var response =
          await _httpService.deleteData("api/breed/", breed.toJson());
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
      var response = await _httpService.deleteData("api/pet", pet.toJson());
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
  Future<ApiStatus> deleteMessage(MessageModel message) async {
    try {
      var response =
          await _httpService.deleteData("api/message", message.toJson());
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
  Future<ApiStatus> deleteHealth(PetHealthInfo health) async {
    try {
      var response =
          await _httpService.deleteData("api/health", health.toJson());
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
  Future<ApiStatus> deleteSecureMeetup(SecureMeetup meetup) async {
    try {
      var response =
          await _httpService.deleteData("api/secureMeetup", meetup.toJson());
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
  Future<ApiStatus> deleteVaccine(SingleVaccine vaccine) async {
    try {
      var response =
          await _httpService.deleteData("api/vaccination/", vaccine.toJson());
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
  Future<ApiStatus> deleteDisease(SingleDisease disease) async {
    try {
      var response =
          await _httpService.deleteData("api/disease/", disease.toJson());
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
  Future<ApiStatus> deleteDisability(SingleDisability disability) async {
    try {
      var response =
          await _httpService.deleteData("api/disability", disability.toJson());
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
  Future<ApiStatus> deleteMeetup(Meetup meetup) async {
    try {
      var response =
          await _httpService.deleteData("api/meetup/", meetup.toJson());
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
  Future<ApiStatus> deleteMeetupVerification(MeetupVerification meetup) async {
    try {
      var response = await _httpService.deleteData(
          "api/verification-meetups/", meetup.toJson());
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
  Future<ApiStatus> deleteUserVerification(UserVerification user) async {
    try {
      var response = await _httpService.deleteData(
          "api/verification-users/", user.toJson());
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
  Future<ApiStatus> deletePayment(Payment payment) async {
    try {
      var response =
          await _httpService.deleteData("api/payment", payment.toJson());
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
  Future<ApiStatus> deleteApplication(ApplicationModel application) async {
    try {
      var response = await _httpService.deleteData(
          "api/application", application.toJson());
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
  Future<ApiStatus> deleteFavourite(Favourite favourite) async {
    try {
      var response = await _httpService.deleteData(
          "api/favourite/byuser", favourite.toJson());
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
  Future<ApiStatus> uploadCnicImage(String filePath, String userId) async {
    try {
      final response = await _httpService.uploadImage(
          'api/verification-users/upload-cnic', {'user_id': userId}, filePath);

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
  Future<ApiStatus> uploadBillImage(String filePath, String userId) async {
    try {
      final response = await _httpService.uploadImage(
          'api/verification-users/upload-proof', {'user_id': userId}, filePath);

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
  Future<ApiStatus> addHealthInfo(HealthInfoModel health) async {
    try {
      var response = await _httpService.postData("api/health", health.toJson());
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

  @override
  Future<ApiStatus> resetPassword(LoginRequest login) async {
    try {
      var response = await _httpService.postData(
          "api/users/reset-password", login.toJson());
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
  Future<ApiStatus> addVaccine(AddInBulk vaccine) async {
    try {
      var response =
          await _httpService.postData("api/vaccination", vaccine.toJson());
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
  Future<ApiStatus> addDisease(AddInBulk disease) async {
    try {
      var response =
          await _httpService.postData("api/disease", disease.toJson());
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
  Future<ApiStatus> addDisability(AddInBulk disability) async {
    try {
      var response =
          await _httpService.postData("api/disability", disability.toJson());
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
  Future<ApiStatus> addMeetup(Meetup meetup) async {
    try {
      var response = await _httpService.postData("api/meetup", meetup.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: Meetup.fromJson(res.data.first),
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
  Future<ApiStatus> addMeetupVerification(MeetupVerification meetup) async {
    try {
      var response = await _httpService.postData(
          "api/verification-meetups", meetup.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
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
  Future<ApiStatus> addUserVerification(UserVerification user) async {
    try {
      var response =
          await _httpService.postData("api/verification-users", user.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: UserVerification.fromJson(res.data),
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
  Future<ApiStatus> addPayment(Payment payment) async {
    try {
      var response =
          await _httpService.postData("api/payment", payment.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: Payment.fromJson(res.data),
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
  Future<ApiStatus> addApplication(ApplicationModel application) async {
    try {
      var response =
          await _httpService.postData("api/application", application.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: ApplicationModel.fromJson(res.data),
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
  Future<ApiStatus> addFavourite(Favourite favoutite) async {
    try {
      var response =
          await _httpService.postData("api/favourite", favoutite.toJson());
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
  Future<ApiStatus> addMessage(MessageModel message) async {
    try {
      var response =
          await _httpService.postData("api/message", message.toJson());
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
  Future<ApiStatus> uploadSecureMeetupImages(
    ProofImages proofImages,
  ) async {
    try {
      final response = await _httpService.uploadMultipleImages(
        'api/secureMeetup/uploadimages',
        {'meetup_id': proofImages.meetupId},
        proofImages.toImageJson()
          ..remove('meetup_id'), // Remove meetup_id from images map
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        return ApiStatus(data: jsonDecode(body), errorCode: "PA0004");
      } else {
        return ApiStatus(
            data: null, errorCode: "SM_UPLOAD_FAIL_${response.statusCode}");
      }
    } catch (e, s) {
      _globalService.logError(
          "Upload Secure Meetup Images Error", e.toString(), s);
      return ApiStatus(data: e, errorCode: "SM_UPLOAD_EXCEPTION");
    }
  }

  @override
  Future<ApiStatus> createPaymentIntent(PaymentIntentRequest request) async {
    try {
      final response =
          await _httpService.postData('api/payment/intent', request.toJson());
      if (response.statusCode == 404) {
        return ApiStatus(data: null, errorCode: "PA0002");
      }
      if (response.statusCode == 401) {
        return ApiStatus(data: null, errorCode: "PA0001");
      }
      ApiResponse res = ApiResponse.fromJson(json.decode(response.body));
      if (response.statusCode == 201) {
        if (res.success ?? true) {
          return ApiStatus(
            data: PaymentIntentResponse.fromJson(res.data),
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
  //<============================Strip Gateway====================================>
  Future<ApiStatus> createPaymentIntent(PaymentIntentRequest request);
//<=========================== Image Upload Requests =======================>
  Future<ApiStatus> uploadSecureMeetupImages(ProofImages image);
  Future<ApiStatus> uploadProfileImage(String filePath, String userId);
  Future<ApiStatus> uploadCnicImage(String filePath, String userId);
  Future<ApiStatus> uploadBillImage(String filePath, String userId);
  Future<ApiStatus> uploadPetImage(String filePath, String petId);

//<=========================== Vaccine Requests =======================>
  Future<ApiStatus> getVaccines();
  Future<ApiStatus> addVaccine(AddInBulk vaccine);
  Future<ApiStatus> addVaccineBulk(AddInBulk vaccines);
  Future<ApiStatus> updateVaccine(Vaccine vaccine);
  Future<ApiStatus> deleteVaccine(SingleVaccine vaccine);

//<=========================== Disease Requests =======================>
  Future<ApiStatus> getDiseases();
  Future<ApiStatus> addDisease(AddInBulk disease);
  Future<ApiStatus> addDiseasesBulk(AddInBulk diseases);
  Future<ApiStatus> updateDisease(Disease disease);
  Future<ApiStatus> deleteDisease(SingleDisease disease);

//<=========================== Disability Requests =======================>
  Future<ApiStatus> getDisability();
  Future<ApiStatus> addDisability(AddInBulk diability);
  Future<ApiStatus> addDisabilityBulk(AddInBulk disability);
  Future<ApiStatus> updateDisability(Disability disability);
  Future<ApiStatus> deleteDisability(SingleDisability disability);

//<=========================== Meetup Requests =======================>
  Future<ApiStatus> addMeetup(Meetup meetup);
  Future<ApiStatus> updateMeetup(Meetup meetup);
  Future<ApiStatus> deleteMeetup(Meetup meetup);
  Future<ApiStatus> getMeetups();
  Future<ApiStatus> getMeetupsByPetId(Meetup meetup);
  Future<ApiStatus> getMeetupsBetweenUserId(Meetup meetup);
  Future<ApiStatus> getMeetupsByUserId(Meetup meetup);
  Future<ApiStatus> getMeetupsById(Meetup meetup);

  Future<ApiStatus> getSecureMeetups();
  Future<ApiStatus> getSecureMeetupsByMeetupID(SecureMeetup meetup);
  Future<ApiStatus> deleteSecureMeetup(SecureMeetup meetup);
  Future<ApiStatus> updateSecureMeetup(SecureMeetup secure);
  Future<ApiStatus> addSecureMeetup(SecureMeetup secure);
  //<=========================== Meetup Verification Requests =======================>
  Future<ApiStatus> addMeetupVerification(MeetupVerification meetup);
  Future<ApiStatus> updateMeetupVerification(MeetupVerification meetup);
  Future<ApiStatus> deleteMeetupVerification(MeetupVerification meetup);
  Future<ApiStatus> getMeetupVerificationById(MeetupVerification meetup);
  Future<ApiStatus> getMeetupVerifications();
  //<=========================== Users Verification Requests =======================>
  Future<ApiStatus> addUserVerification(UserVerification user);
  Future<ApiStatus> updateUserVerification(UserVerification user);
  Future<ApiStatus> deleteUserVerification(UserVerification user);
  Future<ApiStatus> getUserVerificationById(UserVerification user);
  Future<ApiStatus> getUserVerificationByUserId(UserVerification user);
  Future<ApiStatus> getUserVerifications();
  //<=========================== Payment Requests =======================>
  Future<ApiStatus> addPayment(Payment payment);
  Future<ApiStatus> deletePayment(Payment payment);
  Future<ApiStatus> getUserPaymentByUserId(Payment payment);
  Future<ApiStatus> getUserPaymentByPaymentId(Payment payment);
  Future<ApiStatus> getPayments();

  //<=========================== Applications Requests =======================>
  Future<ApiStatus> addApplication(ApplicationModel application);
  Future<ApiStatus> deleteApplication(ApplicationModel application);
  Future<ApiStatus> getUserApplicationBYUserId(ApplicationModel application);
  Future<ApiStatus> getUserApplicationBYId(ApplicationModel application);
  Future<ApiStatus> updateApplication(ApplicationModel application);
  Future<ApiStatus> getApplications();

//<=========================== Favourite Requests =======================>
  Future<ApiStatus> addFavourite(Favourite favourite);
  Future<ApiStatus> deleteFavourite(Favourite favourite);
  Future<ApiStatus> getFavourite(Favourite favourite);

//<=========================== Health Requests =======================>
  Future<ApiStatus> getHealth();
  Future<ApiStatus> getHealthById(PetHealthInfo health);
  Future<ApiStatus> deleteHealth(PetHealthInfo health);
  Future<ApiStatus> updateHealth(HealthInfoModel health);
  Future<ApiStatus> addHealthInfo(HealthInfoModel health);
  Future<ApiStatus> getHealthByPetId(SinglePet pet);

//<=========================== Pet Requests =======================>
  Future<ApiStatus> getPets();
  Future<ApiStatus> getPetById(SinglePet pet);
  Future<ApiStatus> getPetsByAnimalId(PetResponse pet);
  Future<ApiStatus> getPetsByBreedId(PetResponse pet);
  Future<ApiStatus> getPetByUserId(SingleUser user);
  Future<ApiStatus> deletePet(SinglePet pet);
  Future<ApiStatus> updatePet(PetResponse pet);
  Future<ApiStatus> addPet(PetRequest pet);

//<=========================== Messaging Requests =======================>
  Future<ApiStatus> addMessage(MessageModel message);
  Future<ApiStatus> getMessages(MessageInfo message);
  Future<ApiStatus> getMessagesBetweenUsers(MessageModel message);
  Future<ApiStatus> updateMessages(MessageModel message);
  Future<ApiStatus> deleteMessage(MessageModel message);

//<=========================== User Requests =======================>
  Future<ApiStatus> getUserinfo(SingleUser user);
  Future<ApiStatus> getProfile(SingleUser user);
  Future<ApiStatus> getUsers();
  Future<ApiStatus> deleteUser(SingleUser user);
  Future<ApiStatus> updateUser(User user);
  Future<ApiStatus> signUp(SignupRequest signup);
  Future<ApiStatus> login(LoginRequest login);
  Future<ApiStatus> refreshToken(RefreshTokenRequest token);
  Future<ApiStatus> userInfo(UserInfoRequest userInfo);
  Future<ApiStatus> userInfoById(SingleUser userInfo);

//<=========================== Adopter Requests =======================>
  Future<ApiStatus> getAdopters();
  Future<ApiStatus> addAdopter(AddAdopter adopter);
  Future<ApiStatus> deleteAdopter(SingleUser user);
  Future<ApiStatus> updateAdopter(UserProfile user);
  Future<ApiStatus> resetPassword(LoginRequest login);
//<=========================== Donor Requests =======================>
  Future<ApiStatus> getDonors();
  Future<ApiStatus> addDonor(AddDonor donor);
  Future<ApiStatus> deleteDonor(SingleUser user);
  Future<ApiStatus> updateDonor(UserProfile user);

//<=========================== Animal Type & Breed Requests =======================>
  Future<ApiStatus> addAnimalBreed(AddAnimalBreed animal);
  Future<ApiStatus> addAnimalBreedBulk(AddAnimalBreed animal);
  Future<ApiStatus> addAnimalType(AddAnimalType animal);
  Future<ApiStatus> addAnimalTypeBulk(AddAnimalType animal);
  Future<ApiStatus> deleteAnimalType(GetAnimal breed);
  Future<ApiStatus> deleteAnimalBreed(BreedType breed);
  Future<ApiStatus> updateAnimalType(UpdateAnimal animal);
  Future<ApiStatus> updateBreed(UpdateBreed animal);
  Future<ApiStatus> getAnimalType();
  Future<ApiStatus> getAnimalBreeds();
  Future<ApiStatus> getAnimalVaccineById(GetAnimal vaccine);
  Future<ApiStatus> getAnimalDiseaseById(GetAnimal disease);
  Future<ApiStatus> getAnimalDisabilityById(GetAnimal disablility);
  Future<ApiStatus> getAnimalBreed(GetAnimal breed);
}
