import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';
import 'package:petadoption/views/modals/admin_modals/pet_edit_modal.dart';

import 'user_admin_view_model.dart';

class PetAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  PetViewModel get _petViewModel => locator<PetViewModel>();

  UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
  String? path;
  PetResponse? pet;
  List<PetResponse>? pets;
  List<PetResponse>? filteredPets;

  void setPet(PetResponse pet) {
    this.pet = pet;
  }

  void removeImagePath() {
    path = null;
    notifyListeners();
  }

  getGender() async {
    if (pet != null) {
      pet!.gender = await _petViewModel.getGender();

      notifyListeners();
    }
  }

  getBreeds() async {
    if (pet != null) {
      BreedSelection breed = await _petViewModel.getAnimalBreed(pet!.animalId);
      if (breed.selectedBreedId != null && breed.selectedBreedName != null) {
        pet!.breedId = breed.selectedBreedId!;
        pet!.breed = breed.selectedBreedName!;

        notifyListeners();
      }
    }
  }

  void getAnimalType() async {
    if (pet != null) {
      AnimalSelection animal = await _petViewModel.getAnimalType();
      if (animal.selectedAnimalId != null &&
          animal.selectedAnimalName != null) {
        pet!.animalId = animal.selectedAnimalId!;
        pet!.animal = animal.selectedAnimalName!;
        pet!.breed = null;
        pet!.breedId = "";
        notifyListeners();
      }
    }
  }

  Future<void> updatepetImage(String petId) async {
    if (path != null) {
      final status = await _apiService.uploadPetImage(path!, petId);
      if (status.data != null) {
        debugPrint("Upload success: ${status.data}");
      } else {
        debugPrint("Upload failed: ${status.errorCode}");
      }
    }
  }

  Future<void> savePetImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    path = pickedFile.path;

    notifyListeners();
  }

  bool isActive = false;

  void setisActive(bool isActive) {
    this.isActive = isActive;
    notifyListeners();
  }

  Future<void> getPets() async {
    try {
      loading(true);
      var petRes = await _apiService.getPets();

      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredPets = List.from(pets!);
      } else {
        await _dialogService.showApiError(
          petRes.data.status.toString(),
          petRes.data.message.toString(),
          petRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterPets(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredPets = List.from(pets ?? []);
    } else {
      filteredPets = pets
          ?.where(
              (u) => u.userEmail!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredPets = List.from(pets ?? []);
    notifyListeners();
  }

  void gotoEditPet(PetResponse pet) async {
    path=null;
    await _navigationService.pushModalBottom(Routes.pet_edit_modal,
        data: PetEditModal(pet: pet));
  }

  Future<void> deletePet(String petId) async {
    try {
      loading(true, loadingText: "Deleting Pet");
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really want to delete Pet ?"));
      if (res) {
        var resDelete = await _apiService.deletePet(SinglePet(petId: petId));
        if (resDelete.errorCode == "PA0004") {
          debugPrint("User Deleted Sucess Fully");
        } else {
          await _dialogService.showApiError(
              resDelete.data.status.toString(),
              resDelete.data.message.toString(),
              resDelete.data.error.toString());
        }
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      loading(false);
    }
  }

  void updatePet(
    String name,
    int age,
    String description,
    String? rejectionReason,
  ) async {
    try {
      if (pet == null) {
        return;
      }
      loading(true);
      var updatePetrRes = await _apiService.updatePet(PetResponse(
        petId: pet!.petId,
        donorId: pet!.donorId,
        breedId: pet!.breedId,
        animalId: pet!.animalId,
        name: name,
        age: age,
        gender: pet!.gender,
        description: pet!.description,
        isApproved: isApproved,
        rejectionReason: rejectionReason,
        isLive: pet!.isLive,
        animal: pet!.animal,
        breed: pet!.breed,
        userEmail: pet!.userEmail,
      ));

      if (updatePetrRes.errorCode == "PA0004") {
        debugPrint("User Updated Success Fully");
      if(path!=null)
      {
        updatepetImage(pet!.petId);
      }

      } else {
        await _dialogService.showApiError(
            updatePetrRes.data.status.toString(),
            updatePetrRes.data.message.toString(),
            updatePetrRes.data.error.toString());
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  void gotoPrevious() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.admin,
        args: TransitionType.slideLeft);
  }

  bool isEdit = false;
  void setEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void isLive() {
    if (pet != null) {
      pet!.isLive = !(pet!.isLive ?? false);
    }
    notifyListeners();
  }

  List<String> approvalStatus = ["Approved", "Pending", "Rejected"];
  String isApproved = "Approved";

  Color getColor() {
    switch (isApproved) {
      case "Approved":
        return Colors.green;

      case "Pending":
        return Colors.grey;

      case "Rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  getisApproved() async {
    int index = await _dialogService.showSelect(Message(
        description: "Select Status Of Application", items: approvalStatus));
    if (index != -1 && index < approvalStatus.length) {
      isApproved = approvalStatus[index];
      notifyListeners();
    }
  }

  void userInfo(String id) async {
    _userModel.showLink(id,isAdmin: true);
  }

}
