import 'package:flutter/material.dart';
import 'package:petadoption/helpers/error_handler.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/request_models/delete_user.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/models/response_models/meetup_verification.dart';
import 'package:petadoption/models/response_models/payment.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:petadoption/models/response_models/user_verification.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/admin_view_models/user_admin_view_model.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/profile_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';

UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
NavigationService get navigationService => locator<NavigationService>();

class MeetupVerificationViewModel extends BaseViewModel {
  UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();
  ProfileViewModel get _profileModel => locator<ProfileViewModel>();
  List<MeetupVerification>? verifymeetups;
  List<MeetupVerification>? fiteredMeetups;

  String? verificationStatusFilter;
  String searchQuery = "";

  bool isAdmin() {
    return _globalService.getuser()?.role.toString().toLowerCase() == "admin";
  }

  showLink(String userId) {
    _userModel.showLink(userId, isAdmin: isAdmin());
  }

  Future<ApplicationModel?> getApplicationInfo(String applicationId) async {
    try {
      var res = await _apiService.getUserApplicationBYId(
          ApplicationModel(applicationId: applicationId));
      if (res.errorCode == "PA0004") {
        return res.data as ApplicationModel;
      }
      return null;
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
      return null;
    }
  }

  Future<Payment?> getPaymentInfo(String paymentId) async {
    try {
      var res = await _apiService
          .getUserPaymentByPaymentId(Payment(paymentId: paymentId));
      if (res.errorCode == "PA0004") {
        return res.data as Payment;
      }
      return null;
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
      return null;
    }
  }

  Future<UserVerification?> getUserVerificationBYId(
      String verificationId) async {
    try {
      var res = await _apiService.getUserVerificationById(
          UserVerification(verificationId: verificationId));
      if (res.errorCode == "PA0004") {
        return res.data as UserVerification;
      }
      return null;
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
      return null;
    }
  }

  String? userVerificationStatusFilter;
  String? applicationVerificationStatusFilter;

  void setUserVerificationStatusFilter(String? value) {
    userVerificationStatusFilter = value;
    _applyFilters();
  }

  void setApplicationVerificationStatusFilter(String? value) {
    applicationVerificationStatusFilter = value;
    _applyFilters();
  }

  Future<void> getMeetupVerifications() async {
    try {
      loading(true);
      var verRes = await _apiService.getMeetupVerifications();

      if (verRes.errorCode == "PA0004") {
        verifymeetups = (verRes.data as List)
            .map((json) =>
                MeetupVerification.fromJson(json as Map<String, dynamic>))
            .toList();

        for (var a in verifymeetups!) {
          debugPrint(a.toJson().toString());
          if (a.applicationId != null && a.applicationId!.isNotEmpty) {
            var res = await getApplicationInfo(a.applicationId ?? "");
            a.application = res;
          }
          if (a.paymentId != null && a.paymentId!.isNotEmpty) {
            var res = await getPaymentInfo(a.paymentId ?? "");
            a.paymentInfo = res;
          }
          if (a.verificationId != null && a.verificationId!.isNotEmpty) {
            var res = await getUserVerificationBYId(a.verificationId ?? "");
            a.userVerification = res;
          }
        }

        _applyFilters();
      } else {
        await _dialogService.showApiError(verRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Fetching Applications", e.toString(), s);
    } finally {
      loading(false);
    }
  }

  String? paymentStatusFilter;

  void setVerificationStatusFilter(String? value) {
    verificationStatusFilter = value;
    _applyFilters();
  }

  void setPaymentStatusFilter(String? value) {
    paymentStatusFilter = value;
    _applyFilters();
  }

  void setSearchQuery(String value) {
    searchQuery = value.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    if (verifymeetups == null) {
      fiteredMeetups = null;
      notifyListeners();
      return;
    }

    fiteredMeetups = verifymeetups!.where((meetup) {
      final meetsVerification = verificationStatusFilter == null ||
          (meetup.adopterVerificationStatus?.toLowerCase() ==
              verificationStatusFilter);

      final meetsPayment = paymentStatusFilter == null ||
          (meetup.paymentStatus?.toLowerCase() == paymentStatusFilter);

      final userVerificationStatus =
          meetup.userVerification != null ? "done" : "not done";
      final meetsUserVerification = userVerificationStatusFilter == null ||
          userVerificationStatus.toLowerCase() == userVerificationStatusFilter;

      final applicationVerificationStatus =
          meetup.application?.verificationStatus?.toLowerCase() ?? "pending";
      final meetsApplicationVerification =
          applicationVerificationStatusFilter == null ||
              applicationVerificationStatus ==
                  applicationVerificationStatusFilter;

      final meetsSearch = searchQuery.isEmpty ||
          (meetup.meetupId?.toLowerCase().contains(searchQuery) ?? false) ||
          (meetup.userVerification?.userId
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery) ??
              false);

      return meetsVerification &&
          meetsPayment &&
          meetsUserVerification &&
          meetsApplicationVerification &&
          meetsSearch;
    }).toList();

    fiteredMeetups!.sort((a, b) =>
        (b.paymentInfo?.amount ?? 0).compareTo(a.paymentInfo?.amount ?? 0));

    notifyListeners();
  }

  void gotoMeetupVerificationDetails(MeetupVerification meetup) {
    navigationService.pushNamed(Routes.adminmeetupverification,
        data: meetup, args: TransitionType.slideBottom);
  }

  updateMeetupVerification(MeetupVerification meetup) async {
    var res = await _apiService.updateMeetupVerification(meetup);
    if (res.errorCode == "PA0004") {
      if (meetup.application?.verificationStatus.toString().toLowerCase() ==
              "approved" ||
          meetup.paymentId != null) {
        var res = await _apiService.addSecureMeetup(SecureMeetup(
            meetupId: meetup.meetupId,
            approval: meetup.adopterVerificationStatus));
        if (res.errorCode == "PA0004") {
          debugPrint("Secure Meetup Status");
        }
        debugPrint("Update verifictation Status");
      }
    }
  }

  gotoUserVerificationpage(
      String userId, UserVerification? userverification) async {
    try {
      loading(true);
      var res = await _apiService.getMeetupsByUserId(Meetup(userId: userId));
      if (res.errorCode == "PA0004") {
        meets = (res.data as List)
            .map((json) => Meetup.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      if (meets != null) {
        meets!.first.userVerification = userverification;
        // meets!.first.application = application;
        navigationService.pushNamed(Routes.userverification,
            data: meets!.first, args: TransitionType.slideBottom);
      }
    } catch (e, s) {
      printError(error: e.toString(), stack: s.toString(), tag: tag);
    } finally {
      loading(false);
    }
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
