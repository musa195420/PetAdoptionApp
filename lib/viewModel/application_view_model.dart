import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

NavigationService get navigationService => locator<NavigationService>();

class ApplicationViewModel extends BaseViewModel {
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();

  List<ApplicationModel>? applications;

  Future<void> getApplications() async {
    try {
      loading(true);
      var applicationRes = await _apiService.getApplications();

      if (applicationRes.errorCode == "PA0004") {
        applications = (applicationRes.data as List)
            .map((json) =>
                ApplicationModel.fromJson(json as Map<String, dynamic>))
            .toList();
        // filteredDisability = List.from(disabilities!);

        // for (var d in disabilities!) {
        //   final animal = d.animal;
        //   if (animal != null && !animalSelection.contains(animal)) {
        //     animalSelection.add(animal);
        //   }
        // }
      } else {
        await _dialogService.showApiError(applicationRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  Future<void> addApplication(ApplicationModel application) async {
    try {
      loading(true, loadingText: "Submitting Application");
      var addApp = await _apiService.addApplication(application);
      if (addApp.errorCode == "PA0004") {
        application =
            application.copyWithModel(addApp.data as ApplicationModel);

        await _apiService.updateMeetupVerification(MeetupVerification(
            meetupId: application.meetupId,
            applicationId: application.applicationId));
        _dialogService.showGlassyErrorDialog("Application Sent Successfully");
      } else {
        await _dialogService.showApiError(addApp.data);
      }
    } catch (e) {
      loading(false);
    } finally {
      loading(false);
    }
  }
}
