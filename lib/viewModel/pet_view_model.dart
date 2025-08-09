import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/error_handler.dart';
import 'package:petadoption/helpers/image_processor.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/health_info.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/pet_prediction_model.dart';
import 'package:petadoption/models/request_models/animal_breed_request.dart';
import 'package:petadoption/models/request_models/pet_request.dart';
import 'package:petadoption/models/response_models/animal_Type.dart';
import 'package:petadoption/models/response_models/get_disability.dart';
import 'package:petadoption/models/response_models/health_info.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/animalBreed_modal.dart';

import '../models/response_models/breed_type.dart';
import '../models/response_models/get_disease.dart';
import '../models/response_models/get_vaccines.dart';
import '../views/modals/animalDisability_modal.dart';
import '../views/modals/animalDisease_modal.dart';
import '../views/modals/animal_Vaccination_modal.dart';

String tag = "petviewModel";

class PetViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();

  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  StartupViewModel get _startModel => locator<StartupViewModel>();
  GlobalService get _globalService => locator<GlobalService>();

  bool checkVersion = true;
  String? path;
  TextEditingController vaccinationController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController disabilityController = TextEditingController();

  TextEditingController petNameController = TextEditingController();
  TextEditingController animaltypeController = TextEditingController();
  List<AnimalType>? animals;
  List<Map<String, dynamic>>? predictions;
  ImageProcessor get _imageProcessor => locator<ImageProcessor>();

  PetPrediction? predictionsModel;

  void loadModel() async {
    await locator<ImageProcessor>().loadModel();
  }

  Future<void> savePetImagePath() async {
    debugPrint("📸 savePetImagePath() started");

    try {
      final picker = ImagePicker();
      debugPrint("📥 Opening image picker...");
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        debugPrint("❌ No image selected, exiting.");
        return;
      }

      path = pickedFile.path;
      debugPrint("✅ Image selected: $path");

      File selectedImage = File(path!);

      debugPrint("🚀 Running model on selected image...");
      List<Map<String, String>>? rawPredictions =
          await _imageProcessor.runModel(selectedImage);

      debugPrint("📊 rawPredictions length: ${rawPredictions.length}");
      debugPrint("📊 rawPredictions content: $rawPredictions");

      if (rawPredictions.isNotEmpty) {
        debugPrint("✅ Entering predictions processing block...");
        final firstMap = rawPredictions.first;
        debugPrint("📌 First prediction map: $firstMap");

        // Convert to model
        final petPrediction = PetPrediction.fromMap(firstMap, path!);
        debugPrint("📦 Converted to PetPrediction: type=${petPrediction.type}");

        // Store in your viewModel
        predictionsModel = petPrediction;

        debugPrint(
            "📡 Calling setAnimaltype() with type: ${predictionsModel?.type ?? ""}");
        await setAnimaltype(predictionsModel?.type ?? "");
      } else {
        debugPrint("❌ No predictions returned from runModel()");
      }

      // Optionally update controller
      debugPrint("🔔 Notifying listeners...");
      notifyListeners();

      debugPrint("🏁 savePetImagePath() completed");
    } catch (e, s) {
      debugPrint("💥 ERROR in savePetImagePath(): $e");
      debugPrint("📜 Stack trace: $s");
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }
  }

  Future<bool> setAnimaltype(String type) async {
    debugPrint("🐾 setAnimaltype() started with type='$type'");

    try {
      var animalRes =
          await _apiService.getAnimalType().timeout(Duration(seconds: 10));

      debugPrint("📡 API Response errorCode: ${animalRes.errorCode}");
      if (animalRes.errorCode == "PA0004") {
        debugPrint("📦 Animal type API data: ${animalRes.data}");

        // Parse the response
        animals = (animalRes.data as List)
            .map((json) => AnimalType.fromJson(json as Map<String, dynamic>))
            .toList();

        debugPrint("📋 Parsed animals count: ${animals?.length}");

        if (animals != null && animals!.isNotEmpty) {
          for (var animal in animals!) {
            debugPrint("🔍 Checking animal: ${animal.name}");
            if (animal.name.toLowerCase() == type.toLowerCase()) {
              debugPrint(
                  "🎯 Match found! ID=${animal.animalId}, Name=${animal.name}");
              selectedAnimalTypeId = animal.animalId;
              selectedAnimalTypeName = animal.name;
              animaltypeController.text = animal.name;
              return true;
            }
          }
          debugPrint("⚠️ No animal match found for type='$type'");
        } else {
          debugPrint("⚠️ Animals list is empty or null.");
        }
      } else {
        debugPrint(
            "⚠️ API returned unexpected errorCode: ${animalRes.errorCode}");
      }
    } catch (e, s) {
      debugPrint("💥 ERROR in setAnimaltype(): $e");
      debugPrint("📜 Stack trace: $s");
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    }

    return false;
  }

  String? selectedAnimalTypeId;
  String? selectedAnimalTypeName;
  Future<AnimalSelection> getAnimalType() async {
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

          if (selectedIndex >= 0 && selectedIndex < animals!.length) {
            // Assign selected animal_id
            selectedAnimalTypeId = animals![selectedIndex].animalId;
            selectedAnimalTypeName = animals![selectedIndex].name;
            return AnimalSelection(
                selectedAnimalId: selectedAnimalTypeId,
                selectedAnimalName: selectedAnimalTypeName);
          } else {
            debugPrint("No animal selected or invalid selection.");
          }
        }
      } else {
        await _dialogService.showApiError(animalRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
      return AnimalSelection(
          selectedAnimalId: selectedAnimalTypeId,
          selectedAnimalName: selectedAnimalTypeName);
    } finally {
      notifyListeners();
      loading(false);
    }
    return AnimalSelection(
        selectedAnimalId: selectedAnimalTypeId,
        selectedAnimalName: selectedAnimalTypeName);
  }

  String? selectedBreedId;
  String? selectedBreedName;
  List<BreedType>? breeds;

  Future<BreedSelection> getAnimalBreed(String? selectedAnimalTypeId) async {
    try {
      loading(true);
      if (selectedAnimalTypeId != null) {
        var breedRes = await _apiService
            .getAnimalBreed(GetAnimal(id: selectedAnimalTypeId));

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

            if (selectedIndex >= 0 && selectedIndex < breeds!.length) {
              // Assign selected animal_id
              selectedBreedId = breeds![selectedIndex].breedId;
              selectedBreedName = breeds![selectedIndex].name;

              return BreedSelection(
                  selectedBreedId: selectedBreedId!,
                  selectedBreedName: selectedBreedName!);
            } else {
              debugPrint("No animal selected or invalid selection.");
            }
          } else {
            await _dialogService
                .showAlert(Message(description: "No Breed Found For Animal"));
          }
        } else {
          await _dialogService.showApiError(breedRes.data);
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
      return BreedSelection(
          selectedBreedId: selectedBreedId!,
          selectedBreedName: selectedBreedName!);
    } finally {
      notifyListeners();
      loading(false);
    }
    return BreedSelection(
        selectedBreedId: selectedBreedId!,
        selectedBreedName: selectedBreedName!);
  }

  String gender = "Male";

  Future<String> getGender() async {
    List<String> genders = ["Male", "Female"];

    int? selectedIndex = await _dialogService.showSelect(
      Message(description: "Please Select Animal Type", items: genders),
    );

    if (selectedIndex >= 0 && selectedIndex < genders.length) {
      // Assign selected animal_id
      gender = genders[selectedIndex];
    }

    notifyListeners();
    return gender;
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
    try {
      var addpetRes = await _apiService.addPet(PetRequest(
        donorId: _globalService.getuser()!.userId,
        name: name,
        animalId: selectedAnimalTypeId!,
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
        // await   _dialogService.showSuccess(text: "Pet Added SuccessFully");
        await _navigationService.pushNamed(
          Routes.healthinfo,
          data: HealthInfoModel(
              animalId: selectedAnimalTypeId!, petId: pet.petId!),
          args: TransitionType.slideRight,
        );
      } else {
        await _dialogService.showApiError(addpetRes.data);
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  void _uploadPetImage(String path, String petId) async {
    var res = await _apiService.uploadPetImage(path, petId);
    if (res.errorCode == "PA0000") {
      debugPrint(res.toString());
    } else {
      await _dialogService.showApiError(res.data);
    }
  }

  void logout() async {
    await _startModel.logout();
  }
//<=====================================================Health information=================================================>

  String? selectedVaccinationId;
  String? selectedVaccinationName;

  List<Vaccine>? vaccines;
  Future<void> getAnimalVaccination(String? selectedAnimalTypeId) async {
    try {
      loading(true);
      if (selectedAnimalTypeId != null) {
        var res = await _apiService
            .getAnimalVaccineById(GetAnimal(id: selectedAnimalTypeId));

        if (res.errorCode == "PA0004") {
          debugPrint(res.data.toString());

          // Parse the response
          vaccines = (res.data as List)
              .map((json) => Vaccine.fromJson(json as Map<String, dynamic>))
              .toList();

          // Get all names for the dialog
          if (vaccines != null && vaccines!.isNotEmpty) {
            List<String> vaccineNames =
                vaccines!.map((a) => a.name ?? "Not Sepecified").toList();

            // Show select dialog and wait for user selection (assumed returns index)
            int? selectedIndex = await _dialogService.showSelect(
              Message(
                  description: "Please Select Animal Type",
                  items: vaccineNames),
            );

            if (selectedIndex >= 0 && selectedIndex < vaccines!.length) {
              // Assign selected animal_id
              selectedVaccinationId = vaccines![selectedIndex].vaccineId;
              selectedVaccinationName = vaccines![selectedIndex].name;
              vaccinationController =
                  TextEditingController(text: selectedVaccinationName);
            } else {
              debugPrint("No animal selected or invalid selection.");
            }
          } else {
            await _dialogService
                .showAlert(Message(description: "No Breed Found For Animal"));
          }
        } else {
          await _dialogService.showApiError(res.data);
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

  String? selectedDiseaseId;
  String? selectedDiseaseName;

  List<Disease>? diseases;
  Future<void> getAnimalDiseases(String? selectedAnimalTypeId) async {
    try {
      loading(true);
      if (selectedAnimalTypeId != null) {
        var res = await _apiService
            .getAnimalDiseaseById(GetAnimal(id: selectedAnimalTypeId));

        if (res.errorCode == "PA0004") {
          debugPrint(res.data.toString());

          // Parse the response
          diseases = (res.data as List)
              .map((json) => Disease.fromJson(json as Map<String, dynamic>))
              .toList();

          // Get all names for the dialog
          if (diseases != null && diseases!.isNotEmpty) {
            List<String> diseaseNames =
                diseases!.map((a) => a.name ?? "Not Sepecified").toList();

            // Show select dialog and wait for user selection (assumed returns index)
            int? selectedIndex = await _dialogService.showSelect(
              Message(
                  description: "Please Select Disease Type",
                  items: diseaseNames),
            );

            if (selectedIndex >= 0 && selectedIndex < diseases!.length) {
              // Assign selected animal_id
              selectedDiseaseId = diseases![selectedIndex].diseaseId;
              selectedDiseaseName = diseases![selectedIndex].name;
              diseaseController =
                  TextEditingController(text: selectedDiseaseName);
            } else {
              debugPrint("No animal selected or invalid selection.");
            }
          } else {
            await _dialogService
                .showAlert(Message(description: "No Disease Found For Animal"));
          }
        } else {
          await _dialogService.showApiError(res.data);
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

  String? selectedDisabilityId;
  String? selectedDisabilityName;

  List<Disability>? disabilities;
  Future<void> getAnimalDisability(String? selectedAnimalTypeId) async {
    try {
      loading(true);
      if (selectedAnimalTypeId != null) {
        var res = await _apiService
            .getAnimalDisabilityById(GetAnimal(id: selectedAnimalTypeId));

        if (res.errorCode == "PA0004") {
          debugPrint(res.data.toString());

          // Parse the response
          disabilities = (res.data as List)
              .map((json) => Disability.fromJson(json as Map<String, dynamic>))
              .toList();

          // Get all names for the dialog
          if (disabilities != null && disabilities!.isNotEmpty) {
            List<String> diseaseNames =
                disabilities!.map((a) => a.name ?? "Not Sepecified").toList();

            // Show select dialog and wait for user selection (assumed returns index)
            int? selectedIndex = await _dialogService.showSelect(
              Message(
                  description: "Please Select Disability Type",
                  items: diseaseNames),
            );

            if (selectedIndex >= 0 && selectedIndex < disabilities!.length) {
              // Assign selected animal_id
              selectedDisabilityId = disabilities![selectedIndex].disabilityId;
              selectedDisabilityName = disabilities![selectedIndex].name;
              disabilityController =
                  TextEditingController(text: selectedDisabilityName);
            } else {
              debugPrint("No animal selected or invalid selection.");
            }
          } else {
            await _dialogService
                .showAlert(Message(description: "No Breed Found For Animal"));
          }
        } else {
          await _dialogService.showApiError(res.data);
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

  void addDisease(String animalId) async {
    await _navigationService.pushModalBottom(Routes.disease_modal,
        data: AnimalDiseaseModal(animalId: animalId));
  }

  void addDisability(String animalId) async {
    await _navigationService.pushModalBottom(Routes.disability_modal,
        data: AnimalDisabilityModal(animalId: animalId));
  }

  void addVaccination(String animalId) async {
    await _navigationService.pushModalBottom(Routes.vaccination_modal,
        data: AnimalVaccinationModal(animalId: animalId));
  }

  Future<void> updateHealthInfo(String petId, String healthId) async {
    try {
      loading(true, loadingText: "Adding Health Info ..");
      if (selectedDisabilityId != null &&
          selectedDiseaseId != null &&
          selectedVaccinationId != null) {
        var res = await _apiService.updateHealth(HealthInfoModel(
            healthId: healthId,
            petId: petId,
            vaccinationId: selectedVaccinationId,
            diseaseId: selectedDiseaseId,
            disabilityId: selectedDisabilityId));

        if (res.errorCode == "PA0004") {
        } else {
          await _dialogService.showApiError(res.data);
          return;
        }
      } else {
        await _dialogService.showAlert(Message(
            description:
                "Please Select The All Info Again \n You migh Be Missing Something"));
        loading(false);
        return;
      }
    } catch (e, s) {
      loading(false);

      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  Future<void> saveHealthInfo(String petId) async {
    try {
      loading(true, loadingText: "Adding Health Info ..");
      if (selectedAnimalTypeId != null &&
          selectedDisabilityId != null &&
          selectedDiseaseId != null &&
          selectedVaccinationId != null) {
        var res = await _apiService.addHealthInfo(HealthInfoModel(
            petId: petId,
            vaccinationId: selectedVaccinationId,
            diseaseId: selectedDiseaseId,
            disabilityId: selectedDisabilityId));

        if (res.errorCode == "PA0004") {
        } else {
          await _dialogService.showApiError(res.data);
          return;
        }
      } else {
        await _dialogService.showAlert(Message(
            description:
                "Please Select The All Info Again \n You migh Be Missing Something"));
        loading(false);
        return;
      }
    } catch (e, s) {
      loading(false);

      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
      debugPrint(e.toString());
    } finally {
      notifyListeners();
      await _navigationService.pushNamedAndRemoveUntil(Routes.home,
          args: TransitionType.slideTop);
      loading(false);
    }
  }

  bool isHealthInfoReady = false;

  Future<void> setFields(PetHealthInfo info) async {
    isHealthInfoReady = false;
    notifyListeners(); // show loading UI if needed

    selectedVaccinationName = info.vaccinationName;
    selectedVaccinationId = info.vaccinationId;
    selectedDiseaseId = info.diseaseId;
    selectedDiseaseName = info.diseaseName;
    selectedDisabilityId = info.disabilityId;
    selectedDisabilityName = info.disabilityName;

    petNameController = TextEditingController(text: info.petName);
    animaltypeController = TextEditingController(text: info.animalName);
    await setControllers();

    isHealthInfoReady = true;
    notifyListeners(); // now show the updated form
  }

  Future<void> setControllers() async {
    vaccinationController =
        TextEditingController(text: selectedVaccinationName);
    diseaseController = TextEditingController(text: selectedDiseaseName);
    disabilityController = TextEditingController(text: selectedDisabilityName);
    notifyListeners();
  }
}

class BreedSelection {
  final String? selectedBreedId;
  final String? selectedBreedName;

  BreedSelection({this.selectedBreedId, this.selectedBreedName});
}

class AnimalSelection {
  final String? selectedAnimalId;
  final String? selectedAnimalName;

  AnimalSelection({this.selectedAnimalId, this.selectedAnimalName});
}
