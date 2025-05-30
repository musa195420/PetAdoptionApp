import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../models/hive_models/user.dart';
import '../models/request_models/delete_user.dart';
import '../models/request_models/userinforequest.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

class DetailViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();

  PetResponse? pet;
  User? user;

  void goBack() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.home,
        args: TransitionType.slideLeft);
  }

  Future<void> getData(PetResponse pet) async {
    this.pet = pet;
    await getUser(pet.userEmail);
  }

  Future<void> getUser(String? userEmail) async {
    if (userEmail != null) {
      var userRes =
          await _apiService.userInfo(UserInfoRequest(email: userEmail));

      if (userRes.errorCode == "PA0004") {
        user = userRes.data as User;
        notifyListeners();
      } else {
        await _dialogService.showApiError(userRes.data);
      }
    }
  }

  bool checkVersion = true;
  Future<void> logout() async {
    await _startupViewModel.logout();
  }

  List<PetResponse>? pets;
  List<String> petSelection = [];
  List<PetResponse>? filteredPets;

  Future<void> getPets() async {
    try {
      loading(true);

      var petRes = await _apiService.getPets();

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
}
