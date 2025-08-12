// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/custom_widgets/os_map_picker.dart';
import 'package:petadoption/helpers/locator.dart';
// ignore: unused_import
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/application_model.dart';
import 'package:petadoption/models/request_models/proof_image.dart';
import 'package:petadoption/models/request_models/receiver_model.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/models/response_models/payment.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/views/modals/admin_modals/meetup_edit_modal.dart';
import 'package:petadoption/views/modals/admin_modals/secure_edit_modal.dart';

import '../../models/error_models/error_reponse.dart';
import '../../models/request_models/delete_user.dart';
import '../../models/response_models/meetup_verification.dart';
import '../../models/response_models/pet_response.dart';
import '../../models/response_models/secure_meetup.dart';
import '../../views/modals/admin_modals/pet_edit_modal.dart';
import '../../views/modals/payment_modal.dart';
import 'user_admin_view_model.dart';

class SecureMeetupAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  UserAdminViewModel get _userModel => locator<UserAdminViewModel>();
  String? proofPicPath;
  String? adopterIdPath;
  String? adopterIdBackPath;
  List<SecureMeetup>? secureMeetups;
  List<SecureMeetup>? filteredSecure;
  bool isAdmin() {
    return _globalService.getuser()?.role.toString().toLowerCase() == "admin";
  }

  bool isActive = false;

  void setisActive(bool isActive) {
    this.isActive = isActive;
    notifyListeners();
  }

  Color getColor(String approval) {
    switch (approval.toLowerCase()) {
      case 'pending':
        {
          return Colors.grey;
        }

      case 'valid' || 'approved' || 'applied':
        {
          return Colors.green;
        }

      case 'invalid' || 'rejected':
        {
          return Colors.red;
        }

      default:
        return Colors.grey;
    }
  }

  Future<void> getSecureMeetups() async {
    try {
      loading(true);
      var secureRes = await _apiService.getSecureMeetups();

      if (secureRes.errorCode == "PA0004") {
        secureMeetups = (secureRes.data as List)
            .map((json) => SecureMeetup.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredSecure = List.from(secureMeetups!);
      } else {
        await _dialogService.showApiError(secureRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterSecureMeetup(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredSecure = List.from(secureMeetups ?? []);
    } else {
      filteredSecure = secureMeetups
          ?.where((u) =>
              u.currentAddress!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredSecure = List.from(secureMeetups ?? []);
    notifyListeners();
  }

  Future<void> deleteSecureMeetup(String secureId) async {
    try {
      loading(true, loadingText: "Deleting SecureMeetup");
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really want to delete SecureMeetup ?"));
      if (res) {
        var resDelete = await _apiService
            .deleteSecureMeetup(SecureMeetup(secureMeetupId: secureId));
        if (resDelete.errorCode == "PA0004") {
          debugPrint("SecureMeetup Deleted Sucess Fully");
        } else {
          await _dialogService.showApiError(resDelete.data);
        }
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      loading(false);
    }
  }

  void updateSecureMeetup(String phoneNumber, String currentAddress,
      String rejectionReason, SecureMeetup secure) async {
    try {
      loading(true, loadingText: "Secure Meetup Updating ...");

      meetup!.currentAddress = currentAddress;
      meetup!.phoneNumber = phoneNumber;

      var updateRes = await _apiService.updateSecureMeetup(SecureMeetup(
          secureMeetupId: secure.secureMeetupId,
          meetupId: secure.meetupId,
          phoneNumber: phoneNumber,
          currentAddress: currentAddress,
          rejectionReason: rejectionReason,
          approval: meetup!.approval ?? "Pending"));

      if (updateRes.errorCode == "PA0004") {
        debugPrint("Secure Updated Success Fully");

        await _updateImages(secure.meetupId!);
        await getSecureMeetups();
        _dialogService.showSuccess(text: "Secure Updated Success Fully");
      } else {
        await _dialogService.showApiError(updateRes.data);
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  void gotoPrevious() async {
    await _navigationService.pushNamedAndRemoveUntil(Routes.admin,
        args: TransitionType.slideLeft);
  }

  Future<void> _updateImages(String meetupId) async {
    try {
      if (adopterIdBackPath != null ||
          adopterIdPath != null ||
          proofPicPath != null) {
        var res = await _apiService.uploadSecureMeetupImages(ProofImages(
            meetupId: meetupId,
            proofPicPath: proofPicPath,
            adopterIdFrontPath: adopterIdPath,
            adopterIdBackPath: adopterIdBackPath));
        if (res.errorCode == "PA0004") {
          debugPrint("Secure Updated Success Fully");
        } else {
          await _dialogService.showApiError(res.data);
        }
      }
    } catch (e) {
      debugPrint("Error ${e.toString()}");
    }
  }

  SecureMeetup? meetup;

  bool isEdit = false;
  void setSecureMeetup(SecureMeetup meetup) {
    this.meetup = meetup;
  }

  void setEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void gotoEditSecure(SecureMeetup meetup) async {
    try {
      isEdit = false;
      proofPicPath = null;
      adopterIdPath = null;
      adopterIdBackPath = null;
      await _navigationService.pushModalBottom(Routes.securemeetup_config_modal,
          data: SecureEdit(meetup: meetup));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> savePetImagePath(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    switch (type.toLowerCase()) {
      case "proofpicpath":
        {
          proofPicPath = pickedFile.path;
        }
      case "adopteridpath":
        {
          adopterIdPath = pickedFile.path;
        }
      case "adopteridbackpath":
        {
          adopterIdBackPath = pickedFile.path;
        }
    }

    notifyListeners();
  }

  List<String> approvalStatus = ["Valid", "Pending", "Invalid"];

  getisApproved() async {
    int index = await _dialogService.showSelect(Message(
        description: "Select Status Of Application", items: approvalStatus));
    if (index != -1 && index < approvalStatus.length) {
      meetup!.approval = approvalStatus[index];
      notifyListeners();
    }
  }

  List<String> meetupApproval = ["Applied", "Rejected", "Accepted"];

  getmeetupApproved() async {
    int index = await _dialogService.showSelect(Message(
        description: "Select Status Of Application", items: approvalStatus));
    if (index != -1 && index < approvalStatus.length) {
      meetup!.approval = approvalStatus[index];
      notifyListeners();
    }
  }

  void removeImagePath(String type) {
    switch (type.toLowerCase()) {
      case "proofpicpath":
        {
          proofPicPath = null;
        }
      case "adopteridpath":
        {
          adopterIdPath = null;
        }
      case "adopteridbackpath":
        {
          adopterIdBackPath = null;
        }
    }
    notifyListeners();
  }

  //<===========================================================Meetup Edit====================================================>

  bool initailizing = true;
  bool isUpdate = false;
  setisUpdate(bool value) {
    isUpdate = value;
  }

  List<String> paymentStatus = ["Not Paid", "Paid"];

  Future<void> intialMeetupSetup(String userId, String adopterId) async {
    await getUser(userId, adopterId);
    await getpetuserId(donorUser!.userId);
    adopterNameController.text = adopterUser!.email ?? "";
    if (applicationController.text.isEmpty) {
      applicationController.text = meetupApproval.first;
    }
    initailizing = false;
    notifyListeners();
  }

  Meetup? meets;

  Future<void> getMeetup(String meetupId) async {
    try {
      loading(true, loadingText: "Getting Meetup ....");
      var res = await _apiService.getMeetupsById(Meetup(meetupId: meetupId));
      if (res.errorCode == "PA0004") {
        meets = res.data;

        await _navigationService.pushModalBottom(Routes.meetup_edit_modal,
            data: MeetupEdit(meetup: meets!));
      } else {
        await _dialogService.showApiError(res.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading(false);
    } finally {
      loading(false);
    }
  }

  Future<void> getMeetupByUserId(String meetupId) async {
    try {
      loading(true, loadingText: "Getting Meetup ....");
      var res = await _apiService
          .getMeetupsByUserId(Meetup(userId: _globalService.getuser()!.userId));
      if (res.errorCode == "PA0004") {
        meets = res.data;
      } else {
        await _dialogService.showApiError(res.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading(false);
    } finally {
      loading(false);
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      // Check permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      // If all good, get location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e, s) {
      debugPrint("Error ${e.toString()} STack ${s.toString()}");
    }
    return null;
  }

  String? longitude;
  String? latitude;
  Future<void> selectLocationonMaps() async {
    try {
      if (longitude == null || latitude == null) {
        Position? pos = await getCurrentLocation();
        if (pos != null) {
          longitude = pos.longitude.toString();
          latitude = pos.latitude.toString();
        }
      }
      final result = await Navigator.push(
        _navigationService.navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (_) => OSMMapPickerScreen(
                  longitude: double.parse(longitude ?? "74.3079"),
                  latitude: double.parse(latitude ?? "31.5732"),
                )),
      );

      if (result != null) {
        latitude = result['latitude'].toString();
        longitude = result['longitude'].toString();
        locationNameController.text =
            "$latitude, $longitude"; // or resolve address
        notifyListeners();
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  Future<void> selectDateTime() async {
    DateTime? dateTime = await _dialogService.showDateTimePicker();
    if (dateTime != null) {
      timeController.text = dateTime.toString();
    }
    notifyListeners();
  }

  List<String> meetupVerification = [
    'Pending',
    'Applied',
  ];
  Future<void> selectmeetupVerification() async {
    String role = _globalService.getuser()!.role ?? "".toLowerCase();
    if (role == "admin") {
      meetupVerification = ['Pending', 'Applied', 'Approved', 'Rejected'];
    }

    int index = await _dialogService.showSelect(Message(
        description: "Select Application Status", items: meetupVerification));
    if (index != -1 && index < meetupVerification.length) {
      applicationController.text = meetupVerification[index];
      notifyListeners();
    }
  }

  Future<void> selectPet() async {
    if (pets == null) {
      return;
    }
    List<String>? petNames = [];
    for (var p in pets!) {
      petNames.add(p.name ?? "Not Known");
    }

    int index = await _dialogService
        .showSelect(Message(description: "Select Your Pet", items: petNames));
    if (index != -1 && index < petNames.length) {
      petName = pets![index].name;
      petId = pets![index].petId;
      petNameController.text = petName ?? "Enter Pet";
      notifyListeners();
    }
  }

  Future<void> updateMeetup(
    String meetupId,
    String petId,
    String location,
    String latitude,
    String longitude,
    bool isAcceptedByDonor,
    bool isAcceptedByAdopter, {
    String? donorVerificationRequest,
    String? adopterVerificationRequest,
  }) async {
    try {
      loading(true, loadingText: "Updating Meetup ....");

      Meetup updatedMeetup = Meetup(
        meetupId: meetupId,
        petId: petId,
        location: location,
        latitude: latitude,
        longitude: longitude,
        time: timeController.text,
        isAcceptedByAdopter: isAcceptedByAdopter,
        isAcceptedByDonor: isAcceptedByDonor,
        addVerification: applicationController.text,
      );

      var res = await _apiService.updateMeetup(updatedMeetup);
      if (res.errorCode == "PA0004") {
        if (applicationController.text.toLowerCase() == "pending") {
          var verRes = await _apiService
              .deleteMeetupVerification(MeetupVerification(meetupId: meetupId));
          if (verRes.errorCode == "PA0004") {
            _dialogService.showSuccess(text: "Updated Meetup");
          }
        }
        if (applicationController.text.toLowerCase() == "applied") {
          var verRes =
              await _apiService.addMeetupVerification(MeetupVerification(
            meetupId: meetupId,
            adopterVerificationStatus: meetupVerification[0],
            paymentStatus: paymentStatus[0],
          ));
          if (verRes.errorCode == "PA0004") {
            _dialogService.showSuccess(text: "Updated Meetup");
          }
        }
      } else {
        await _dialogService.showApiError(res.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading(false);
    } finally {
      loading(false);
    }
  }

  Future<void> deleteMeetup(
    String meetupId,
  ) async {
    try {
      loading(true, loadingText: "Deleting Meetup ....");

      var res = await _apiService.deleteMeetup(Meetup(meetupId: meetupId));
      if (res.errorCode == "PA0004") {
        _dialogService.showSuccess(text: "Deleted Meetup");
      } else {
        await _dialogService.showApiError(res.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading(false);
    } finally {
      loading(false);
    }
  }

  Future<ReceiverModel> getReceiverInfo(String userId) async {
    try {
      var userRes = await _apiService.getUserinfo(SingleUser(userId: userId));
      if (userRes.errorCode == "PA0004") {
        return userRes.data as ReceiverModel;
      } else {
        return ReceiverModel(userId: "");
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
      return ReceiverModel(userId: "");
    }
  }

  String getRole() {
    String role = _globalService.getuser()!.role.toString().toLowerCase();
    return role;
  }

  String? meetupId;
  ReceiverModel? donorUser;
  ReceiverModel? adopterUser;
  TextEditingController petNameController = TextEditingController();
  TextEditingController adopterNameController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController applicationController = TextEditingController();
  bool isAcceptedByDonor = false;
  bool isAcceptedByAdopter = false;
  String? petId;
  String? petName;
  Future<void> addMeetup(
    String userId,
    String receiverId,
    String petId,
    String donorId,
    String adopterId,
    String location,
    String latitude,
    String longitude,
    bool isAcceptedByDonor,
    bool isAcceptedByAdopter, {
    String? donorVerificationRequest,
    String? adopterVerificationRequest,
  }) async {
    try {
      loading(true, loadingText: "Add Meetup ....");

      if (donorUser!.isVerified == null || adopterUser!.isVerified == null) {
        _dialogService.showApiError(
            ErrorResponse(message: "User Not Found", error: "604"));
      }
      // Fallback if values are null

      Meetup addMeetup = Meetup(
        petId: petId,
        donorId: donorId,
        adopterId: adopterId,
        location: location,
        latitude: latitude,
        longitude: longitude,
        time: timeController.text,
        isAcceptedByAdopter: isAcceptedByAdopter,
        isAcceptedByDonor: isAcceptedByDonor,
        addVerification: applicationController.text,
      );

      var res = await _apiService.addMeetup(addMeetup);
      if (res.errorCode == "PA0004") {
        Meetup meetup = res.data;
        if ((meetup.addVerification ?? "pending").toLowerCase() == "pending") {
          _dialogService.showSuccess(text: "Add Meetup");
          return;
        }
        var verRes = await _apiService.addMeetupVerification(MeetupVerification(
          meetupId: meetup.meetupId ?? "",
          adopterVerificationStatus: meetupVerification[0],
          paymentStatus: paymentStatus[0],
        ));
        if (verRes.errorCode == "PA0004") {
          _dialogService.showSuccess(text: "Add Meetup");
        }
      } else {
        await _dialogService.showApiError(res.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      loading(false);
    } finally {
      setisUpdate(true);
      loading(false);
      notifyListeners();
    }
  }

  void setMeetup(Meetup meets) {
    this.meets = meets;
  }

  setDefault() {
    meetupId = null;
    petNameController.text = "";
    petId = null;
    petName = null;
    adopterNameController.text = "";
    locationNameController.text = "";
    longitude = null;
    latitude = null;
    timeController.text = "";
    applicationController.text = "";
    isAcceptedByAdopter = false;
    isAcceptedByDonor = false;
  }

  void setData(Meetup meets) {
    this.meets = meets;
    meetupId = meets.meetupId;
    petNameController.text = meets.petName ?? "";
    petId = meets.petId;
    petName = meets.petName;
    adopterNameController.text = meets.adopterName ?? "";
    locationNameController.text = meets.location ?? "";
    longitude = meets.longitude;
    latitude = meets.latitude;
    timeController.text = meets.time ?? "";
    applicationController.text = meets.addVerification ?? "";
    isAcceptedByAdopter = meets.isAcceptedByAdopter ?? false;
    isAcceptedByDonor = meets.isAcceptedByDonor ?? false;
  }

  void showPetInfo(String? petId) async {
    try {
      loading(true, loadingText: "Gathering Pet Info");
      var res = await _apiService.getPetById(SinglePet(petId: petId!));
      if (res.errorCode == "PA0004") {
        PetResponse pet = res.data as PetResponse;
        await _navigationService.pushModalBottom(Routes.pet_edit_modal,
            data: PetEditModal(pet: pet));
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  List<PetResponse>? pets;
  Future<void> getpetuserId(String userId) async {
    var petRes = await _apiService.getPetByUserId(SingleUser(userId: userId));

    if (petRes.errorCode == "PA0004") {
      // Parse the response
      pets = (petRes.data as List)
          .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
          .toList();

      // Get all names for the dialog
    }
  }

  Future<void> getUser(String userId, String adopterId) async {
    donorUser = await getReceiverInfo(userId);
    adopterUser = await getReceiverInfo(adopterId);
  }

  setpet(String petId, petName) {
    this.petId = petId;
    this.petName = petName;
    petNameController = petName;
  }

  Future<void> getUserInfo(String id) async {
    _userModel.showLink(id);
  }

  void setacceptedbyDonor(bool value) {
    isAcceptedByDonor = value;
    notifyListeners();
  }

  void setacceptedbyAdopter(bool value) {
    if (!verificationLock) {
      isAcceptedByAdopter = value;
      notifyListeners();
    }
  }

  bool adopterverificationRequest = false;
  bool donorverificationRequest = false;
  void setadopterverificationRequest(bool value) {
    adopterverificationRequest = value;
    notifyListeners();
  }

  void setdonorverificationRequest(bool value) {
    donorverificationRequest = value;
    notifyListeners();
  }

  //<==================================================================Donor Verification=================================================>
  bool isAdopter = false;
  bool isDonor = false;
  Payment? payment;
  Future<void> getPaymentInfo(String adopterId) async {
    try {
      var res =
          await _apiService.getUserPaymentByUserId(Payment(userId: adopterId));
      if (res.errorCode == "PA0004") {
        payment = res.data as Payment;
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  ApplicationModel? application;
  Future<void> getApplicationInfo(String adopterId) async {
    try {
      var res = await _apiService
          .getUserApplicationBYUserId(ApplicationModel(userId: adopterId));
      if (res.errorCode == "PA0004") {
        application = res.data as ApplicationModel;
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  gotoVerificationPage() {
    _navigationService.pushNamed(Routes.userverification,
        data: null, args: TransitionType.slideTop);
  }

  bool verificationLock = true;
  void isLock() {
    if (isAdopter && meets!.addVerification == "Applied") {
      if (payment != null) {
        verificationLock = false;
        return;
      }
      if (application != null &&
          application!.verificationStatus == "Approved") {
        verificationLock = false;
        return;
      }
    } else {
      verificationLock = false;
      return;
    }
    verificationLock = true;
    return;
  }

  void gotoPaymentPage() async {
    _navigationService.pushModalBottom(Routes.payment_modal,
        data: PaymentModal(
          user: _globalService.getuser()!,
          meetup: meets!,
        ));
  }
}
