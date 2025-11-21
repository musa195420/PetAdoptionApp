import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:petadoption/views/modals/detail_modal.dart';

import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

class HomeViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();
  final List<String> imagePaths = [
    'assets/carousel/carousel1.png',
    'assets/carousel/carousel2.png',
    'assets/carousel/carousel3.png',
    'assets/carousel/carousel4.png',
  ];
  bool checkVersion = true;
  Future<void> logout() async {
    await _startupViewModel.logout();
  }

  List<PetResponse>? pets;
  List<String> petSelection = [];
  List<PetResponse>? filteredPets;
  bool isSearching = false;
  String searchQuery = "";

  // Add this method to toggle search mode
  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      // Clear search when closing
      searchQuery = "";
      searchPets("");
    }
    notifyListeners();
  }

  // Add this method to handle search
  void searchPets(String query) {
    searchQuery = query;

    if (query.trim().isEmpty) {
      // If search is empty, apply current animal filter or show all
      if (selectedAnimal.isEmpty) {
        unfilterAnimals();
      } else {
        filteredSelection(selectedAnimal);
      }
    } else {
      // Search across all pets, combining with animal filter if active
      filteredPets = pets?.where((pet) {
        final matchesSearch =
            pet.name?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final matchesAnimal = selectedAnimal.isEmpty ||
            (pet.animal?.toLowerCase() == selectedAnimal.toLowerCase());
        return matchesSearch && matchesAnimal;
      }).toList();
    }
    notifyListeners();
  }

  Future<void> getPets() async {
    try {
      loading(true);
      selectedAnimal = "";
      var petRes = await _apiService.getPets();
      await _globalService.getfavourites();
      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredPets = List.from(pets!);

        for (var d in pets!) {
          final animal = d.animal;
          if (animal != null && !petSelection.contains(animal)) {
            petSelection.add(animal);
          }
        }
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

  void unfilterAnimals() {
    filteredPets = List.from(pets ?? []);
  }

  void viewAll(value) {
    boolValue = value;
    if (value) {
      selectedAnimal = "";
      unfilterAnimals();
    }
    notifyListeners();
  }

  String selectedAnimal = "";

  void filteredSelection(String name) {
    if (name == selectedAnimal) {
      selectedAnimal = "";
      unfilterAnimals();
      notifyListeners();
      return;
    }
    boolValue = false;
    selectedAnimal = name;
    if (name.trim().isEmpty) {
      unfilterAnimals();
    } else {
      filteredPets = pets
          ?.where((u) => u.animal!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
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

  int _tabIndex = 2;

  bool boolValue = false;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    notifyListeners();
  }

  Future<void> gotoDetail(PetResponse pet) async {
    await _navigationService.pushModalBottom(Routes.detail_modal,
        data: DetailModal(pet: pet));
  }
}
