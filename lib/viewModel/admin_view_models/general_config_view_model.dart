import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/request_models/update_animal.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';
import 'package:petadoption/views/modals/pet_edit_modal.dart';

import '../../models/response_models/animal_Type.dart';
import 'user_admin_view_model.dart';

class GeneralConfigViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  PetViewModel get _petViewModel => locator<PetViewModel>();

  UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
  List<AnimalType>? animals;
  List<AnimalType>? filteredAnimals;
  AnimalType? animal;
 String? animalId;
  String? animalName;

set(AnimalType animal)
{
  this.animal=animal;
}

  Future<void> getPets() async {
    try {
      loading(true);
     var animalRes = await _apiService.getAnimalType();

      if (animalRes.errorCode == "PA0004") {
        animals = (animalRes.data as List)
            .map((json) => AnimalType.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredAnimals = List.from(animals!);
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
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filteredAnimal(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredAnimals = List.from(animals ?? []);
    } else {
      filteredAnimals = animals
          ?.where(
              (u) => u.name.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredAnimals = List.from(animals ?? []);
    notifyListeners();
  }

  bool showAnimals=true;
  setshowAnimal(bool value)
  {
 showAnimals=value;
 notifyListeners();
  }

  void gotoPrevious() async{
     if(showAnimals)
     {
       await _navigationService.pushNamedAndRemoveUntil(Routes.admin, args: TransitionType.slideLeft);
     }
     else
     {
      showAnimals=true;
      notifyListeners();
     }
  }

  void gotoEditAnimal(AnimalType animals) {
    animalName=animals.name;
    animalId=animals.animalId;
 showAnimals=false;
 notifyListeners();

  }

  void updateAnimal(String id, String name) async {
  try{
    loading(true,loadingText: "Updating Animal");
    var updateRes= await _apiService.updateAnimalType(UpdateAnimal(animalId: id, name: name));
    loading(false);
     if(updateRes.errorCode=="PA0004")
    {
      debugPrint("Animal Updated Success Fully");
      await getPets();
      showAnimals=true;
      notifyListeners();
    }
    else{
      await _dialogService.showApiError(
                updateRes.data.status.toString(),
                updateRes.data.message.toString(),
                updateRes.data.error.toString());

    }

  
  }catch(e)
  {
debugPrint("Error General Config viewModel =${e.toString()}");
loading(false);
  }
}
}