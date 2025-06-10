import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';
import 'package:petadoption/views/modals/admin_modals/pet_edit_modal.dart';

import '../../models/response_models/health_info.dart';
import '../../views/modals/admin_modals/health_info_modal.dart';
import '../models/request_models/favourite.dart';
import '../views/modals/detail_modal.dart';

class FavouriteViewmodel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();

  User? user;

  List<Favourite>? favourites;
  List<Favourite>? filteredFavourite;
  Favourite? favourite;

  bool isFavourite(String petId) {
    if (favourites != null) {
      for (var fav in favourites!) {
        if (fav.petId == petId) {
          favourite = fav; // set the matched favourite
          return true;
        }
      }
    }
    favourite = null; // clear if not found
    return false;
  }
  // Future<void> gotoDetailPet(favResponse pet) async {
  //   try {
  //     loading(true);
  //     var res = await _apiService.getHealthByPetId(SinglePet(petId: pet.petId));

  //     if (res.errorCode == "PA0004") {
  //       await _navigationService.pushModalBottom(Routes.health_modal,
  //           data: HealthInfoModal(
  //             info: res.data as PetHealthInfo,
  //           ));
  //     } else {
  //       await _dialogService.showApiError(res.data);
  //     }
  //   } catch (e, s) {
  //     _globalService.logError("Error Occured", e.toString(), s);
  //   } finally {
  //     loading(false);
  //   }
  // }
  Future<void> getFavourites() async {
    try {
      user = _globalService.getuser();
      if (user == null) {
        return;
      }
      String userId = user!.userId;
      loading(true);
      var favRes = await _apiService.getFavourite(Favourite(userId: userId));

      if (favRes.errorCode == "PA0004") {
        favourites = (favRes.data as List)
            .map((json) => Favourite.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredFavourite = List.from(favourites!);
      } else {
        await _dialogService.showApiError(favRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Fetching Favourites", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  Future<void> addFavourites(String petId) async {
    try {
      String userId = user!.userId;
      loading(true);
      var favRes = await _apiService
          .addFavourite(Favourite(userId: userId, petId: petId));

      if (favRes.errorCode == "PA0004") {
        _dialogService.showSuccess(text: "Added To Favourites SuccessFully");
        await getFavourites();
      } else {
        await _dialogService.showApiError(favRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Fetching Favourites", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterFavourites(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredFavourite = List.from(favourites ?? []);
    } else {
      filteredFavourite = favourites
          ?.where(
              (u) => u.pet!.name!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredFavourite = List.from(favourites ?? []);
    notifyListeners();
  }

  Future<void> deleteFavourites(String petId) async {
    try {
      loading(true, loadingText: "Removing Favourite");
      String userId = user!.userId;
      var resDelete = await _apiService
          .deleteFavourite(Favourite(petId: petId, userId: userId));
      if (resDelete.errorCode == "PA0004") {
        _dialogService.showSuccess(text: "Removed From Favourites");
        await getFavourites();
      } else {
        await _dialogService.showApiError(resDelete.data);
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      loading(false);
    }
  }

  Future<void> gotoDetail(PetResponse pet) async {
    try {
      loading(true, loadingText: "Gathering Pet Info");
      var res = await _apiService.getPetById(SinglePet(petId: pet.petId!));
      if (res.errorCode == "PA0004") {
        PetResponse pet = res.data as PetResponse;

        await _navigationService.pushModalBottom(Routes.detail_modal,
            data: DetailModal(pet: pet));
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }
}
