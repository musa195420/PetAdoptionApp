import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/proof_image.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/views/modals/admin_modals/meetup_edit_modal.dart';
import 'package:petadoption/views/modals/admin_modals/secure_edit_modal.dart';

import '../../models/response_models/pet_response.dart';
import '../../models/response_models/secure_meetup.dart';
import '../../views/modals/admin_modals/pet_edit_modal.dart';
import 'user_admin_view_model.dart';

class SecuremeetupAdminViewModel extends BaseViewModel {
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

  bool isActive = false;

  void setisActive(bool isActive) {
    this.isActive = isActive;
    notifyListeners();
  }

  Color getColor(String approval) {
    switch (approval) {
      case 'Pending':
        {
          return Colors.grey;
        }

      case 'Valid':
        {
          return Colors.green;
        }

      case 'Invalid':
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
        await _dialogService.showApiError(
          secureRes.data
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
          await _dialogService.showApiError(
              resDelete.data);
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
Meetup? meets;

 Future<void> getMeetup(String meetupId) async
 {
try{
loading(true,loadingText: "Getting Meetup ....");
  var res = await _apiService.getMeetupsById(Meetup(meetupId: meetupId));
   if (res.errorCode == "PA0004") {

         meets=res.data;

         await _navigationService.pushModalBottom(Routes.meetup_edit_modal,data: MeetupEdit(meetup: meets!));
          debugPrint("Secure Updated Success Fully");
        } else {
            await _dialogService.showApiError(res.data);
        }
}catch(e)
{
debugPrint(e.toString());
 loading(false);
}finally{
  loading(false);
}
 }

 void setMeetup(Meetup meets) {
    this.meets = meets;
  }

  void showPetInfo(String? petId) async{
try{
 loading(true,loadingText: "Gathering Pet Info");
  var res= await _apiService.getPetById(SinglePet(petId: petId!));
   if(res.errorCode=="PA0004")
   {
    PetResponse pet = res.data as PetResponse;
 await _navigationService.pushModalBottom(Routes.pet_edit_modal,
        data: PetEditModal(pet: pet));
   }



  
}catch(e)
{
  loading(false);
  debugPrint(e.toString());
}finally{
  loading(false);
}
  }

  Future<void> getUserInfo(String id)async
  {
    _userModel.showLink(id);
  }
}
