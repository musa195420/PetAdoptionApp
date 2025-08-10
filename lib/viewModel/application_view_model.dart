import 'package:petadoption/helpers/error_handler.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/request_models/delete_user.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/admin_view_models/user_admin_view_model.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
NavigationService get navigationService => locator<NavigationService>();

class ApplicationViewModel extends BaseViewModel {
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();
  List<ApplicationModel>? applications;
  List<ApplicationModel>? filteredApplications;

  String? verificationStatusFilter;
  String searchQuery = "";

  bool isAdmin() {
    return _globalService.getuser()?.role.toString().toLowerCase() == "admin";
  }

  Future<void> getApplications() async {
    try {
      loading(true);
      var applicationRes = await _apiService.getApplications();

      if (applicationRes.errorCode == "PA0004") {
        applications = (applicationRes.data as List)
            .map((json) =>
                ApplicationModel.fromJson(json as Map<String, dynamic>))
            .toList();

        for (var a in applications!) {
          var res = await _apiService
              .userInfoById(SingleUser(userId: a.userId ?? ""));
          if (res.errorCode == "PA0004") {
            a.user = res.data as User;
          }
        }

        _applyFilters();
      } else {
        await _dialogService.showApiError(applicationRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Fetching Applications", e.toString(), s);
    } finally {
      loading(false);
    }
  }

  void setVerificationStatusFilter(String? status) {
    verificationStatusFilter = status;
    _applyFilters();
  }

  void _applyFilters() {
    if (applications == null) return;

    filteredApplications = applications!.where((app) {
      final matchesStatus = verificationStatusFilter == null ||
          (app.verificationStatus ?? "").toLowerCase() ==
              verificationStatusFilter;

      final matchesSearch = searchQuery.isEmpty ||
          (app.user?.email ?? "").toLowerCase().contains(searchQuery);

      return matchesStatus && matchesSearch;
    }).toList();

    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query.toLowerCase();
    _applyFilters();
  }

  String tag = "Application ViewModel";
  List<Meetup>? meets;
  gotoApplicatiopage(String userId, ApplicationModel application) async {
    try {
      loading(true);
      var res = await _apiService.getMeetupsByUserId(Meetup(userId: userId));
      if (res.errorCode == "PA0004") {
        meets = (res.data as List)
            .map((json) => Meetup.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      if (meets != null) {
        meets!.first.application = application;
        navigationService.pushNamed(Routes.application,
            data: meets!.first, args: TransitionType.slideTop);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    } finally {
      loading(false);
    }
  }

  void userInfo(String id) async {
    _userModel.showLink(id, isAdmin: true);
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

  Future<void> updateApplication(ApplicationModel application) async {
    try {
      loading(true, loadingText: "Submitting Application");
      var addApp = await _apiService.updateApplication(application);
      if (addApp.errorCode == "PA0004") {
        _dialogService.showGlassyErrorDialog("Application Sent Successfully");
      } else {
        await _dialogService.showApiError(addApp.data);
        loading(false);
      }
    } catch (e) {
      loading(false);
    } finally {
      loading(false);
    }
  }
}
