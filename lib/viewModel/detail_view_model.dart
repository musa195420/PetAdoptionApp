import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/response_models/message_info.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/message_view_model.dart';

import '../models/hive_models/user.dart';
import '../models/request_models/userinforequest.dart';
import '../services/dialog_service.dart';
import '../services/global_service.dart';
import '../services/navigation_service.dart';

class DetailViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();

  MessageViewModel get messageViewmodel => locator<MessageViewModel>();
  PetResponse? pet;
  bool isFavourite = false;
  User? user;

  void goBack() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.home,
        args: TransitionType.slideLeft);
  }

  Future<void> getData(PetResponse pet) async {
    this.pet = pet;
    isFavourite = isfavourite();
    await getUser(pet.userEmail);
  }

  void gotoMessage() async {
    await messageViewmodel.gotoMessagePage(MessageInfo(userId: user!.userId));
  }

  bool isfavourite() {
    return _globalService.favouriteViewmodel.isFavourite(pet!.petId ?? "");
  }

  Future<void> addFavourite() async {
    await _globalService.favouriteViewmodel.addFavourites(pet!.petId ?? "");

    isFavourite = isfavourite();
    notifyListeners();
  }

  Future<void> removeFavourite() async {
    await _globalService.favouriteViewmodel.deleteFavourites(pet!.petId ?? "");
    isFavourite = isfavourite();
    notifyListeners();
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
}
