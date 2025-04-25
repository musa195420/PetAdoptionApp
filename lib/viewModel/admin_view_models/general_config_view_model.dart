import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/add_bulk.dart';
import 'package:petadoption/models/request_models/animal_breed_request.dart';
import 'package:petadoption/models/request_models/single_disability.dart';
import 'package:petadoption/models/request_models/single_disease.dart';
import 'package:petadoption/models/request_models/single_vaccine.dart';
import 'package:petadoption/models/request_models/update_animal.dart';
import 'package:petadoption/models/request_models/update_breed.dart';
import 'package:petadoption/models/response_models/breed_reponse.dart';
import 'package:petadoption/models/response_models/breed_type.dart';
import 'package:petadoption/models/response_models/get_disease.dart';
import 'package:petadoption/models/response_models/get_vaccines.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';

import '../../models/request_models/animalType_request.dart';
import '../../models/request_models/animal_breed.dart';
import '../../models/response_models/animal_Type.dart';
import '../../models/response_models/get_disability.dart';
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

  set(AnimalType animal) {
    this.animal = animal;
  }

  Future<void> getPets() async {
    try {
      showSearch = true;
      addInfo = false;

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
          ?.where((u) => u.name.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredAnimals = List.from(animals ?? []);
    notifyListeners();
  }

  bool showSearch = true;
  setshowAnimal(bool value) {
    showSearch = value;
    notifyListeners();
  }

  bool addInfo = false;
  bool addinBulk = false;
  int selectedIndex = 0;

  setselectedIndex(int index) {
    selectedIndex = index;
    addinBulk = selectedIndex == 1;

    notifyListeners();
  }

  setAddAnimal(bool value) {
    addInfo = value;
    showSearch = false;
    animalName = null;
    breedName = null;
    notifyListeners();
  }

  void gotoPrevious() async {
    if (showSearch && !addInfo) {
      await _navigationService.pushNamedAndRemoveUntil(Routes.admin,
          args: TransitionType.slideLeft);
    } else {
      showSearch = true;
      addInfo = false;
      notifyListeners();
    }
  }

  void gotoEditAnimal(AnimalType animals) {
    animalName = animals.name;
    animalId = animals.animalId;
    showSearch = false;
    notifyListeners();
  }

  void deleteAnimal(String id) async {
    try {
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really Want To Delete This Animal"));
      if (res) {
        loading(true, loadingText: "Updating Animal");
        var deleteRes =
            await _apiService.deleteAnimalType(GetAnimalBreed(id: id));
        loading(false);
        if (deleteRes.errorCode == "PA0004") {
          debugPrint("Animal Deleted Success Fully");
          await getPets();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              deleteRes.data.status.toString(),
              deleteRes.data.message.toString(),
              deleteRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    } finally {
      loading(false);
    }
  }

  void updateAnimal(String id, String name) async {
    try {
      loading(true, loadingText: "Updating Animal");
      var updateRes = await _apiService
          .updateAnimalType(UpdateAnimal(animalId: id, name: name));
      loading(false);
      if (updateRes.errorCode == "PA0004") {
        debugPrint("Animal Updated Success Fully");
        await getPets();
        showSearch = true;
        notifyListeners();
      } else {
        await _dialogService.showApiError(updateRes.data.status.toString(),
            updateRes.data.message.toString(), updateRes.data.error.toString());
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    }
  }

  void addAnimal(String name) async {
    try {
      loading(true);

      if (addinBulk) {
        // Split comma-separated names, trim whitespace
        List<String> namesList = name.split(',').map((e) => e.trim()).toList();

        var addAnimalRes = await _apiService
            .addAnimalTypeBulk(AddAnimalType(names: namesList));

        // Check response for bulk addition if needed
        if (addAnimalRes.errorCode == "PA0004") {
          debugPrint("Animals Added Successfully");
          await getPets();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              addAnimalRes.data.status.toString(),
              addAnimalRes.data.message.toString(),
              addAnimalRes.data.error.toString());
        }
      } else {
        var addAnimalRes =
            await _apiService.addAnimalType(AddAnimalType(name: name));

        if (addAnimalRes.errorCode == "PA0004") {
          debugPrint("Animal Added Successfully");
          await getPets();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              addAnimalRes.data.status.toString(),
              addAnimalRes.data.message.toString(),
              addAnimalRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error in addAnimal: ${e.toString()}");
    } finally {
      loading(false);
    }
  }

//<===============================================Breed Config Model==============================================================>

  List<BreedResponse>? filteredBreeds;
  List<BreedResponse>? breeds;

  List<String> animalSelection = [];
  String selectedAnimal = "";

  Future<void> getBreeds() async {
    try {
      loading(true);
      var breedRes = await _apiService.getAnimalBreeds();

      if (breedRes.errorCode == "PA0004") {
        breeds = (breedRes.data as List)
            .map((json) => BreedResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredBreeds = List.from(breeds!);

        for (var b in breeds!) {
          final animal = b.animal;
          if (animal != null && !animalSelection.contains(animal)) {
            animalSelection.add(animal);
          }
        }
      } else {
        await _dialogService.showApiError(
          breedRes.data.status.toString(),
          breedRes.data.message.toString(),
          breedRes.data.error.toString(),
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

  void resetFilterBreed() {
    filteredBreeds = List.from(breeds ?? []);
    notifyListeners();
  }

  void filteredSelection(String name) {
    selectedAnimal = name;
    if (name.trim().isEmpty) {
      filteredBreeds = List.from(breeds ?? []);
    } else {
      filteredBreeds = breeds
          ?.where((u) => u.animal!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filtereBreeds(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredBreeds = List.from(breeds ?? []);
    } else {
      filteredBreeds = breeds
          ?.where((u) => u.name.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void getAnimals() async {
    AnimalSelection animal = await _petViewModel.getAnimalType();
    if (animal.selectedAnimalId != null && animal.selectedAnimalName != null) {
      animalId = animal.selectedAnimalId;
      animalName = animal.selectedAnimalName;
      notifyListeners();
    }
  }

  String? breedId;
  String? breedName;

  void updateBreed(String breedName, String animalName) async {
    try {
      loading(true, loadingText: "Updating Breed");
      var updateRes = await _apiService.updateBreed(UpdateBreed(
          animalId: animalId ?? "", breedId: breedId ?? "", name: breedName));
      loading(false);
      if (updateRes.errorCode == "PA0004") {
        debugPrint("Animal Updated Success Fully");
        await getBreeds();
        showSearch = true;
        notifyListeners();
      } else {
        await _dialogService.showApiError(updateRes.data.status.toString(),
            updateRes.data.message.toString(), updateRes.data.error.toString());
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    }
  }

  void gotoEditBreed(BreedResponse breed) {
    animalName = breed.animal;
    animalId = breed.animalId;
    breedName = breed.name;
    breedId = breed.breedId;
    showSearch = false;
    notifyListeners();
  }

  void deleteBreed(String id) async {
    try {
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really Want To Delete This Animal"));
      if (res) {
        loading(true, loadingText: "Deleting Breed");
        var deleteRes = await _apiService
            .deleteAnimalBreed(BreedType(breedId: id, name: breedName ?? ""));
        loading(false);
        if (deleteRes.errorCode == "PA0004") {
          debugPrint("Animal Deleted Success Fully");
          await getBreeds();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              deleteRes.data.status.toString(),
              deleteRes.data.message.toString(),
              deleteRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    } finally {
      loading(false);
    }
  }

  void addBreeds(String name) async {
    try {
      loading(true);
      if (animalId != null) {
        if (addinBulk) {
          List<String> namesList =
              name.split(',').map((e) => e.trim()).toList();

          // 🔥 Create a list of AddAnimalBreed objects from breed names
          List<AddAnimalBreed> breedObjects = namesList.map((breedName) {
            return AddAnimalBreed(animalId: animalId!, name: breedName);
          }).toList();

          // 👇 Pass this as the `names` (which is actually 'breeds') parameter
          var addAnimalRes = await _apiService.addAnimalBreedBulk(
              AddAnimalBreed(animalId: animalId!, names: breedObjects));

          if (addAnimalRes.errorCode == "PA0004") {
            debugPrint("Animals Added Successfully");
            await getPets();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addAnimalRes.data.status.toString(),
                addAnimalRes.data.message.toString(),
                addAnimalRes.data.error.toString());
          }
        } else {
          var addBreedRes = await _apiService.addAnimalBreed(
              AddAnimalBreed(animalId: animalId ?? "", name: name));

          if (addBreedRes.errorCode == "PA0004") {
            debugPrint("Animal Added Successfully");
            await getPets();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addBreedRes.data.status.toString(),
                addBreedRes.data.message.toString(),
                addBreedRes.data.error.toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error in addAnimal: ${e.toString()}");
    } finally {
      loading(false);
    }
  }

//====================================================GetVaccinations=======================================>

  List<Vaccine>? filteredVaccines;
  List<Vaccine>? vaccines;
  String? vaccineId;
  String? vaccineName;
  String? description;
  void gotoEditVaccine(Vaccine vaccine) {
    animalName = vaccine.animal;
    animalId = vaccine.animalId;
    vaccineName = vaccine.name;
    vaccineId = vaccine.vaccineId;
    description = vaccine.description;
    showSearch = false;
    notifyListeners();
  }

  Future<void> getVaccinations() async {
    try {
      loading(true);
      var vaccineRes = await _apiService.getVaccines();

      if (vaccineRes.errorCode == "PA0004") {
        vaccines = (vaccineRes.data as List)
            .map((json) => Vaccine.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredVaccines = List.from(vaccines!);

        for (var b in vaccines!) {
          final animal = b.animal;
          if (animal != null && !animalSelection.contains(animal)) {
            animalSelection.add(animal);
          }
        }
      } else {
        await _dialogService.showApiError(
          vaccineRes.data.status.toString(),
          vaccineRes.data.message.toString(),
          vaccineRes.data.error.toString(),
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

  void resetFilterVaccines() {
    filteredVaccines = List.from(vaccines ?? []);
    notifyListeners();
  }

  void filteredSelectionVaccines(String name) {
    selectedAnimal = name;
    if (name.trim().isEmpty) {
      filteredVaccines = List.from(vaccines ?? []);
    } else {
      filteredVaccines = vaccines
          ?.where((u) => u.animal!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filtereVaccines(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredVaccines = List.from(vaccines ?? []);
    } else {
      filteredVaccines = vaccines
          ?.where((u) => u.name!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void deleteVaccine(String id) async {
    try {
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really Want To Delete This Vaccine"));
      if (res) {
        loading(true, loadingText: "Deleting Vaccine");
        var deleteRes =
            await _apiService.deleteVaccine(SingleVaccine(vaccineId: id));
        loading(false);
        if (deleteRes.errorCode == "PA0004") {
          debugPrint("Animal Deleted Success Fully");
          await getVaccinations();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              deleteRes.data.status.toString(),
              deleteRes.data.message.toString(),
              deleteRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    } finally {
      loading(false);
    }
  }

  void updateVaccine(String vaccineName, String description) async {
    try {
      loading(true, loadingText: "Updating Vaccine");
      var updateRes = await _apiService.updateVaccine(Vaccine(
        vaccineId: vaccineId!,
        animalId: animalId,
        name: vaccineName,
        description: description,
      ));
      loading(false);
      if (updateRes.errorCode == "PA0004") {
        await getVaccinations();
        showSearch = true;
        notifyListeners();
      } else {
        await _dialogService.showApiError(updateRes.data.status.toString(),
            updateRes.data.message.toString(), updateRes.data.error.toString());
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    }
  }

  void addVaccines(String name, String description) async {
    try {
      loading(true);
      if (animalId != null) {
        if (addinBulk) {
          List<String> namesList =
              name.split(',').map((e) => e.trim()).toList();

          // 🔥 Create a list of AddAnimalBreed objects from breed names
          List<AddInBulk> vaccineObject = namesList.map((breedName) {
            return AddInBulk(
                animalId: animalId!, name: breedName, description: description);
          }).toList();

          // 👇 Pass this as the `names` (which is actually 'breeds') parameter
          var addAnimalRes = await _apiService.addVaccineBulk(AddInBulk(
              animalId: animalId!,
              names: vaccineObject,
              description: description));

          if (addAnimalRes.errorCode == "PA0004") {
            debugPrint("Animals Added Successfully");
            await getVaccinations();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addAnimalRes.data.status.toString(),
                addAnimalRes.data.message.toString(),
                addAnimalRes.data.error.toString());
          }
        } else {
          var addBreedRes = await _apiService
              .addVaccine(AddInBulk(animalId: animalId ?? "", name: name));

          if (addBreedRes.errorCode == "PA0004") {
            debugPrint("Animal Added Successfully");
            await getVaccinations();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addBreedRes.data.status.toString(),
                addBreedRes.data.message.toString(),
                addBreedRes.data.error.toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error in addAnimal: ${e.toString()}");
    } finally {
      loading(false);
    }
  }


  
//====================================================GetDiseases=======================================>

  List<Disease>? filteredDisease;
  List<Disease>? diseases;
  String? diseaseId;
  String? diseaseName;


Future<void> getDiseases() async {
    try {
      loading(true);
      var diseaseRes = await _apiService.getDiseases();

      if (diseaseRes.errorCode == "PA0004") {
        diseases = (diseaseRes.data as List)
            .map((json) => Disease.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredDisease = List.from(diseases!);

        for (var d in diseases!) {
          final animal = d.animal;
          if (animal != null && !animalSelection.contains(animal)) {
            animalSelection.add(animal);
          }
        }
      } else {
        await _dialogService.showApiError(
          diseaseRes.data.status.toString(),
          diseaseRes.data.message.toString(),
          diseaseRes.data.error.toString(),
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

  void gotoEditDiseases(Disease disease) {
    animalName = disease.animal;
    animalId = disease.animalId;
    diseaseName = disease.name;
    diseaseId = disease.diseaseId;
    description = disease.description;
    showSearch = false;
    notifyListeners();
  }

  void resetFilterDisease() {
    filteredDisease = List.from(diseases ?? []);
    notifyListeners();
  }
void filteredDiseases(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredDisease = List.from(diseases ?? []);
    } else {
      filteredDisease = diseases
          ?.where((u) => u.name!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
  void filteredSelectionDisease(String name) {
    selectedAnimal = name;
    if (name.trim().isEmpty) {
      filteredDisease = List.from(diseases ?? []);
    } else {
      filteredDisease = diseases
          ?.where((u) => u.animal!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addDiseases(String name, String description) async {
    try {
      loading(true);
      if (animalId != null) {
        if (addinBulk) {
          List<String> namesList =
              name.split(',').map((e) => e.trim()).toList();

          // 🔥 Create a list of AddAnimalBreed objects from breed names
          List<AddInBulk> diseaseObject = namesList.map((diseaseName) {
            return AddInBulk(
                animalId: animalId!, name: diseaseName, description: description);
          }).toList();

          // 👇 Pass this as the `names` (which is actually 'breeds') parameter
          var addAnimalRes = await _apiService.addDiseasesBulk(AddInBulk(
              animalId: animalId!,
              names: diseaseObject,
              description: description));

          if (addAnimalRes.errorCode == "PA0004") {
            debugPrint("Animals Added Successfully");
           await getDiseases();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addAnimalRes.data.status.toString(),
                addAnimalRes.data.message.toString(),
                addAnimalRes.data.error.toString());
          }
        } else {
          var addDiseaseRes = await _apiService
              .addDisease(AddInBulk(animalId: animalId ?? "", name: name));

          if (addDiseaseRes.errorCode == "PA0004") {
            debugPrint("Animal Added Successfully");
            await getDiseases();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addDiseaseRes.data.status.toString(),
                addDiseaseRes.data.message.toString(),
                addDiseaseRes.data.error.toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error in addAnimal: ${e.toString()}");
    } finally {
      loading(false);
    }
  }

   void updateDisease(String diseaseName, String description) async {
    try {
      loading(true, loadingText: "Updating Disease");
      var updateRes = await _apiService.updateDisease(Disease(
        diseaseId: diseaseId!,
        animalId: animalId,
        name: diseaseName,
        description: description,
      ));
      loading(false);
      if (updateRes.errorCode == "PA0004") {
        await getVaccinations();
        showSearch = true;
        notifyListeners();
      } else {
        await _dialogService.showApiError(updateRes.data.status.toString(),
            updateRes.data.message.toString(), updateRes.data.error.toString());
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    }
  }

  void deleteDisease(String id) async {
    try {
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really Want To Delete This Vaccine"));
      if (res) {
        loading(true, loadingText: "Deleting Vaccine");
        var deleteRes =
            await _apiService.deleteDisease(SingleDisease(diseaseId: id));
        loading(false);
        if (deleteRes.errorCode == "PA0004") {
          debugPrint("Animal Deleted Success Fully");
          await getDiseases();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              deleteRes.data.status.toString(),
              deleteRes.data.message.toString(),
              deleteRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    } finally {
      loading(false);
    }
  }

  //<=================================================Disability=========================================================>
  List<Disability>? filteredDisability;
  List<Disability>? disabilities;
  String? disabilityId;
  String? disabilityName;


Future<void> getDisabilities() async {
    try {
      loading(true);
      var disabilityRes = await _apiService.getDisability();

      if (disabilityRes.errorCode == "PA0004") {
        disabilities = (disabilityRes.data as List)
            .map((json) => Disability.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredDisability = List.from(disabilities!);

        for (var d in disabilities!) {
          final animal = d.animal;
          if (animal != null && !animalSelection.contains(animal)) {
            animalSelection.add(animal);
          }
        }
      } else {
        await _dialogService.showApiError(
          disabilityRes.data.status.toString(),
          disabilityRes.data.message.toString(),
          disabilityRes.data.error.toString(),
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

  void gotoEditDisability(Disability disease) {
    animalName = disease.animal;
    animalId = disease.animalId;
    disabilityName = disease.name;
    disabilityId = disease.disabilityId;
    description = disease.description;
    showSearch = false;
    notifyListeners();
  }

  void resetFilterDisability() {
    filteredDisability = List.from(disabilities ?? []);
    notifyListeners();
  }
void filteredDisabilities(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredDisability = List.from(disabilities ?? []);
    } else {
      filteredDisability = disabilities
          ?.where((u) => u.name!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
  void filteredSelectionDisabilities(String name) {
    selectedAnimal = name;
    if (name.trim().isEmpty) {
      filteredDisability = List.from(disabilities ?? []);
    } else {
      filteredDisability = disabilities
          ?.where((u) => u.animal!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addDisabilities(String name, String description) async {
    try {
      loading(true);
      if (animalId != null) {
        if (addinBulk) {
          List<String> namesList =
              name.split(',').map((e) => e.trim()).toList();

          // 🔥 Create a list of AddAnimalBreed objects from breed names
          List<AddInBulk> diseaseObject = namesList.map((disabilityName) {
            return AddInBulk(
                animalId: animalId!, name: disabilityName, description: description);
          }).toList();

          // 👇 Pass this as the `names` (which is actually 'breeds') parameter
          var addAnimalRes = await _apiService.addDisabilityBulk(AddInBulk(
              animalId: animalId!,
              names: diseaseObject,
              description: description));

          if (addAnimalRes.errorCode == "PA0004") {
            debugPrint("Animals Added Successfully");
           await getDisabilities();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addAnimalRes.data.status.toString(),
                addAnimalRes.data.message.toString(),
                addAnimalRes.data.error.toString());
          }
        } else {
          var addDiseaseRes = await _apiService
              .addDisability(AddInBulk(animalId: animalId ?? "", name: name));

          if (addDiseaseRes.errorCode == "PA0004") {
            debugPrint("Animal Added Successfully");
            await getDisabilities();
            showSearch = true;
            notifyListeners();
          } else {
            await _dialogService.showApiError(
                addDiseaseRes.data.status.toString(),
                addDiseaseRes.data.message.toString(),
                addDiseaseRes.data.error.toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error in addAnimal: ${e.toString()}");
    } finally {
      loading(false);
    }
  }

   void updateDisability(String disabilityName, String description) async {
    try {
      loading(true, loadingText: "Updating Disease");
      var updateRes = await _apiService.updateDisability(Disability(
        disabilityId: disabilityId!,
        animalId: animalId,
        name: disabilityName,
        description: description,
      ));
      loading(false);
      if (updateRes.errorCode == "PA0004") {
        await getVaccinations();
        showSearch = true;
        notifyListeners();
      } else {
        await _dialogService.showApiError(updateRes.data.status.toString(),
            updateRes.data.message.toString(), updateRes.data.error.toString());
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    }
  }

  void deleteDisability(String id) async {
    try {
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really Want To Delete This Vaccine"));
      if (res) {
        loading(true, loadingText: "Deleting Vaccine");
        var deleteRes =
            await _apiService.deleteDisability(SingleDisability(disabilityId: id));
        loading(false);
        if (deleteRes.errorCode == "PA0004") {
          debugPrint("Animal Deleted Success Fully");
          await getDiseases();
          showSearch = true;
          notifyListeners();
        } else {
          await _dialogService.showApiError(
              deleteRes.data.status.toString(),
              deleteRes.data.message.toString(),
              deleteRes.data.error.toString());
        }
      }
    } catch (e) {
      debugPrint("Error General Config viewModel =${e.toString()}");
      loading(false);
    } finally {
      loading(false);
    }
  }
}
