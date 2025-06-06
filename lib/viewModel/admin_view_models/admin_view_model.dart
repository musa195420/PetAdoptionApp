import 'package:flutter/material.dart';
import '../../helpers/locator.dart';
import '../../models/selection_box_model.dart';
import '../../services/navigation_service.dart';
import '../startup_viewmodel.dart';

class AdminViewModel extends ChangeNotifier {
  int? expandedBoxId;
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();
  NavigationService get _navigationService => locator<NavigationService>();
  final Map<int, List<String>> subItemsMap = {
    0: ['Config User', 'Config Adopter', 'Config Donor'],
    1: ['Pets Config'],
    2: ['Secure Meetup'],
    3: ['HealthInfo Config'],
    4: ['Animal Type', 'Breeds', 'Vaccination', 'Disease', 'Disability'],
  };

  final List<SelectionBox> boxes = [
    SelectionBox(id: 0, name: "User Config", image: "assets/images/user.png"),
    SelectionBox(id: 1, name: "Pets Config", image: "assets/images/login.png"),
    SelectionBox(
        id: 4, name: "General Config", image: "assets/images/settings.png"),
    SelectionBox(
        id: 2, name: "Meetup Config", image: "assets/images/meetup.png"),
    SelectionBox(
        id: 3, name: "HealthInfo Config", image: "assets/images/health.png"),
  ];

  void toggleBox(int id) {
    if (expandedBoxId == id) {
      expandedBoxId = null; // collapse
    } else {
      expandedBoxId = id; // expand
    }
    notifyListeners();
  }

  void onSubItemTapped(String title) async {
    switch (title.toLowerCase()) {
      case 'config user':
        {
          await _navigationService.pushNamed(Routes.userAdmin,
              data: null, args: TransitionType.slideRight);
        }
        break;
      case 'config adopter':
        {
          await _navigationService.pushNamed(Routes.adopterAdmin,
              data: null, args: TransitionType.slideRight);
        }
        break;
      case 'config donor':
        {
          await _navigationService.pushNamed(Routes.donorAdmin,
              data: null, args: TransitionType.slideRight);
        }
        break;

      case 'pets config':
        {
          await _navigationService.pushNamed(Routes.petAdmin,
              data: null, args: TransitionType.slideRight);
        }
        break;
      case 'animal type':
        {
          await _navigationService.pushModalBottom(Routes.animal_config_modal,
              data: null);
        }
        break;
      case 'breeds':
        {
          await _navigationService.pushModalBottom(Routes.breed_config_modal,
              data: null);
        }

      case 'vaccination':
        {
          await _navigationService
              .pushModalBottom(Routes.vaccination_config_modal, data: null);
        }
      case 'disease':
        {
          await _navigationService.pushModalBottom(Routes.disease_config_modal,
              data: null);
        }
      case 'disability':
        {
          await _navigationService
              .pushModalBottom(Routes.disability_config_modal, data: null);
        }

      case 'secure meetup':
        {
          await _navigationService.pushNamedAndRemoveUntil(Routes.secureAdmin,
              args: TransitionType.slideRight);
        }
      case 'healthinfo config':
        {
          await _navigationService.pushNamedAndRemoveUntil(Routes.healthAdmin,
              args: TransitionType.slideRight);
        }
    }
  }

  void logout() async {
    await _startupViewModel.logout();
  }
}
