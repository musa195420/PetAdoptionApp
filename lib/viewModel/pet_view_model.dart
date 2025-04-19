import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/animal_breed_request.dart';
import 'package:petadoption/models/request_models/pet_request.dart';
import 'package:petadoption/models/response_models/animal_Type.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/db_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/authentication_view_model.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/animalBreed_modal.dart';

import '../models/response_models/breed_type.dart';

class PetViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  NavigationService get _navigationService => locator<NavigationService>();

  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  StartupViewModel get _startModel => locator<StartupViewModel>();

  GlobalService get _globalService => locator<GlobalService>();

  bool checkVersion = true;
  String? path;

  List<AnimalType>? animals;
  Future<void> savePetImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    path = pickedFile.path;

    notifyListeners();
  }

  String? selectedAnimalTypeId;
  String? selectedAnimalTypeName;
  Future<void> getAnimalType() async {
    try {
      loading(true);

      var animalRes = await _apiService.getAnimalType();

      if (animalRes.errorCode == "PA0004") {
        debugPrint(animalRes.data.toString());

        // Parse the response
        animals = (animalRes.data as List)
            .map((json) => AnimalType.fromJson(json as Map<String, dynamic>))
            .toList();

        // Get all names for the dialog
        if (animals != null || animals!.isNotEmpty) {
          List<String> animalNames = animals!.map((a) => a.name).toList();

          // Show select dialog and wait for user selection (assumed returns index)
          int? selectedIndex = await _dialogService.showSelect(
            Message(
                description: "Please Select Animal Type", items: animalNames),
          );

          if (selectedIndex != null &&
              selectedIndex >= 0 &&
              selectedIndex < animals!.length) {
            // Assign selected animal_id
            selectedAnimalTypeId = animals![selectedIndex].animalId;
            selectedAnimalTypeName = animals![selectedIndex].name;

            debugPrint("Selected Animal ID: $selectedAnimalTypeName");
          } else {
            debugPrint("No animal selected or invalid selection.");
          }
        }
      } else {
        await _dialogService.showApiError(
          animalRes.data.status.toString(),
          animalRes.data.message.toString(),
          animalRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  String? selectedBreedId;
  String? selectedBreedName;
  List<BreedType>? breeds;
  Future<void> getAnimalBreed() async {
    try {
      loading(true);
      if (selectedAnimalTypeId != null) {
        var breedRes = await _apiService
            .getAnimalBreed(GetAnimalBreed(id: selectedAnimalTypeId!));

        if (breedRes.errorCode == "PA0004") {
          debugPrint(breedRes.data.toString());

          // Parse the response
          breeds = (breedRes.data as List)
              .map((json) => BreedType.fromJson(json as Map<String, dynamic>))
              .toList();

          // Get all names for the dialog
          if (breeds != null && breeds!.isNotEmpty) {
            List<String> breedNames = breeds!.map((a) => a.name).toList();

            // Show select dialog and wait for user selection (assumed returns index)
            int? selectedIndex = await _dialogService.showSelect(
              Message(
                  description: "Please Select Animal Type", items: breedNames),
            );

            if (selectedIndex != null &&
                selectedIndex >= 0 &&
                selectedIndex < breeds!.length) {
              // Assign selected animal_id
              selectedBreedId = breeds![selectedIndex].animalId;
              selectedBreedName = breeds![selectedIndex].name;

              debugPrint("Selected Animal ID: $selectedBreedName");
            } else {
              debugPrint("No animal selected or invalid selection.");
            }
          } else {
            await _dialogService
                .showAlert(Message(description: "No Breed Found For Animal"));
          }
        } else {
          await _dialogService.showApiError(
            breedRes.data.status.toString(),
            breedRes.data.message.toString(),
            breedRes.data.error.toString(),
          );
        }
      } else {
        await _dialogService.showAlert(
            Message(description: "Please Select The Animal Type First"));
        loading(false);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  String gender = "Male";

  void getGender() async {
    List<String> genders = ["Male", "Female"];

    int? selectedIndex = await _dialogService.showSelect(
      Message(description: "Please Select Animal Type", items: genders),
    );

    if (selectedIndex >= 0 && selectedIndex < genders.length) {
      // Assign selected animal_id
      gender = genders[selectedIndex];

      debugPrint("Selected Animal ID: $selectedBreedName");
    }

    notifyListeners();
  }

  void addanimalType() async {
    await _navigationService.pushModalBottom(Routes.animalType_modal,
        data: null);
  }

  void addanimalBreed() async {
    if (selectedAnimalTypeId != null) {
      await _navigationService.pushModalBottom(Routes.animalBreed_modal,
          data: AnimalbreedModal(petId: selectedAnimalTypeId!));
    } else {
      await _dialogService.showAlert(
          Message(description: "Please Select The Animal Type First"));
      loading(false);
    }
  }

  void removeImage() {
    path = null;
    notifyListeners();
  }

  Future<void> savePetImage(String petId) async {
    if (path != null) {
      final status = await _apiService.uploadPetImage(path!, petId);
      if (status.data != null) {
        debugPrint("Upload success: ${status.data}");
      } else {
        debugPrint("Upload failed: ${status.errorCode}");
      }
    }
  }

  Future<void> addPet(String name, int age, String description) async {
    var addpetRes = await _apiService.addPet(PetRequest(
      donorId: await _globalService.getuser()!.userId,
      name: name,
      animalType: selectedAnimalTypeId!,
      isLive: false,
      breedId: selectedBreedId!,
      age: age,
      gender: gender,
      description: description,
    ));
    if (addpetRes.errorCode == "PA0004") {
      PetRequest pet = addpetRes.data as PetRequest;
      if (path != null) {
        _uploadPetImage(path!, pet.petId!);
      }
    } else {
      await _dialogService.showApiError(
        addpetRes.data.status.toString(),
        addpetRes.data.message.toString(),
        addpetRes.data.error.toString(),
      );
    }
  }

  void _uploadPetImage(String path, String petId) async {
    var res = await _apiService.uploadPetImage(path, petId);
    if (res.errorCode == "PA0000") {
      debugPrint(res.toString());
    } else {
      await _dialogService.showApiError(
        res.data.status.toString(),
        res.data.message.toString(),
        res.data.error.toString(),
      );
    }
  }

  void logout() async {
    await _startModel.logout();
  }
}
