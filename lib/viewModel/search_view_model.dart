import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/animal_breed_request.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/detail_modal.dart';

import '../models/response_models/animal_Type.dart';
import '../models/response_models/breed_type.dart';

class SearchViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();

  List<AnimalType>? animals;
  AnimalType? animal;
  String? animalId;
  String? animalName;
  bool get isBusy => busy;
  Future<void> getAnimalType() async {
    try {
      loading(true);
      var animalRes = await _apiService.getAnimalType();

      if (animalRes.errorCode == "PA0004") {
        animals = (animalRes.data as List)
            .map((json) => AnimalType.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        await _dialogService.showApiError(animalRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  List<BreedType>? breeds;
  BreedType? breed;
  String? breedId;
  String? breedName;
  List<String>? breedNames;
  Future<void> getAnimalBreed(String? animalId) async {
    try {
      breeds = null;
      if (animalId != null) {
        var breedRes =
            await _apiService.getAnimalBreed(GetAnimal(id: animalId));

        if (breedRes.errorCode == "PA0004") {
          debugPrint(breedRes.data.toString());

          // Parse the response
          breeds = (breedRes.data as List)
              .map((json) => BreedType.fromJson(json as Map<String, dynamic>))
              .toList();

          // Get all names for the dialog
          if (breeds != null && breeds!.isNotEmpty) {
            breedNames = breeds!.map((a) => a.name).toList();

            // Show select dialog and wait for user selection (assumed returns index)
          }
        }
      } else {
        await _dialogService.showAlert(
            Message(description: "Please Select The Animal Type First"));
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

  List<PetResponse>? pets;
  PetResponse? pet;

  User getuser() {
    return _globalService.getuser()!;
  }

  Future<void> getPets() async {
    try {
      pets = null;
      loading(true);

      var petRes = await _apiService.getPets();
      await _globalService.getfavourites();
      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        await _dialogService.showApiError(petRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  Future<void> getPetsByAnimalId(String animalId) async {
    try {
      pets = null;
      var petRes =
          await _apiService.getPetsByAnimalId(PetResponse(animalId: animalId));

      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getPetsByBreedId(String breedId) async {
    try {
      pets = null;

      var petRes =
          await _apiService.getPetsByBreedId(PetResponse(breedId: breedId));

      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // await _dialogService.showApiError(petRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
    }
  }

  void clearFilters() {
    animal = null;
    animalId = null;
    breed = null;
    breedId = null;
    notifyListeners();
    getPets();
  }

  void selectAnimal(AnimalType a) {
    animal = a;
    animalId = a.animalId;
    breed = null;
    breedId = null;
    notifyListeners();
    getAnimalBreed(animalId);
    getPetsByAnimalId(animalId!);
  }

  void selectBreed(BreedType b) {
    breed = b;
    breedId = b.breedId;
    notifyListeners();
    getPetsByBreedId(breedId!);
  }

  String getSvgs(String name) {
    switch (name.toLowerCase()) {
      case "cat":
        return "assets/svg/cat.png";
      case "dog":
        return "assets/svg/dog.png";
      case "bear":
        return "assets/svg/bear.png";
      case "cow":
        return "assets/svg/cow.png";
      case "tiger":
        return "assets/svg/tiger.png";
      case "rabbit":
        return "assets/svg/rabbit.png";
      default:
        return "assets/svg/animal.png";
    }
  }

  Future<void> gotoDetail(PetResponse pet) async {
    await _navigationService.pushModalBottom(Routes.detail_modal,
        data: DetailModal(pet: pet));
  }

  bool showMore = false;

  void setShowMore(bool value) {
    showMore = value;
    notifyListeners();
  }

  bool showAllCategories = false;
  toggleShowAllCategories() {
    showAllCategories = !showAllCategories;
    notifyListeners();
  }
}
