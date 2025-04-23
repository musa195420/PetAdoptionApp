import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/delete_user.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/views/modals/donor_edit_modal.dart';
class DonorAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
 String ?path;
  List<UserProfile>? donors;
  List<UserProfile>? filteredDonors;

bool isActive=false;

void setisActive(bool isActive)
{
 this.isActive=isActive;
  notifyListeners();
}




  Future<void> getDonors() async {
    try {
      loading(true);
      var donorsRes = await _apiService.getDonors();

      if (donorsRes.errorCode == "PA0004") {
        donors = (donorsRes.data as List)
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredDonors = List.from(donors!);
      } else {
        await _dialogService.showApiError(
          donorsRes.data.status.toString(),
          donorsRes.data.message.toString(),
          donorsRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError("Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterDonors(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredDonors = List.from(donors ?? []);
    } else {
      filteredDonors = donors
          ?.where((u) => u.name.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredDonors = List.from(donors ?? []);
    notifyListeners();
  }

  

  void gotoEditAdopter(UserProfile adopter)async {
  
        await _navigationService.pushModalBottom(Routes.donor_edit_modal,
          data:DonorEditModal(user:adopter));
      
  }
 Future<void> deleteAdopter(String userId) async {
   try{
    loading(true,loadingText: "Deleting User");
    bool res=await _dialogService.showAlertDialog(Message(description:"Do you Really want to delete User ?"));
   if(res)
   {
   var resDelete= await _apiService.deleteDonor(SingleUser(userId:userId) );
   if(resDelete.errorCode=="PA0004")
   {
    debugPrint("User Deleted Sucess Fully");
   }
   else{
     await _dialogService.showApiError(
                resDelete.data.status.toString(),
                resDelete.data.message.toString(),
                resDelete.data.error.toString());
   }
   }
  
   }catch(e)
   {
     loading(false);
    debugPrint("Error => $e");
   }
   finally{
     loading(false);
   }
 }

  void updateDonor(String name, String location,UserProfile user)async {

   try{
    
    loading(true);
     var updateUserRes=await _apiService.updateDonor(
      UserProfile(donorId: user.donorId,name: name,location: location,isActive: isActive)
    );

    if(updateUserRes.errorCode=="PA0004")
    {
      debugPrint("User Updated Success Fully");
      
    }
    else{
      await _dialogService.showApiError(
                updateUserRes.data.status.toString(),
                updateUserRes.data.message.toString(),
                updateUserRes.data.error.toString());

    }
   }
   catch(e)
   {
    
     loading(false);
debugPrint(e.toString());
   }
   finally{
    loading(false);
   }
  }

  void gotoPrevious() async{
    await _navigationService.pushNamedAndRemoveUntil(Routes.admin, args: TransitionType.slideLeft);
  }
  

 
}
