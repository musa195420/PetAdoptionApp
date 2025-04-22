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
import 'package:petadoption/views/modals/adopter_edit_model.dart';
class AdopterAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
 String ?path;
  List<UserProfile>? adopters;
  List<UserProfile>? filteredAdopters;

bool isActive=false;

void setisActive(bool isActive)
{
 this.isActive=isActive;
  notifyListeners();
}




  Future<void> getAdopters() async {
    try {
      loading(true);
      var adoptersRes = await _apiService.getAdopters();

      if (adoptersRes.errorCode == "PA0004") {
        adopters = (adoptersRes.data as List)
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredAdopters = List.from(adopters!);
      } else {
        await _dialogService.showApiError(
          adoptersRes.data.status.toString(),
          adoptersRes.data.message.toString(),
          adoptersRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError("Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterAdopters(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredAdopters = List.from(adopters ?? []);
    } else {
      filteredAdopters = adopters
          ?.where((u) => u.name.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredAdopters = List.from(adopters ?? []);
    notifyListeners();
  }

  

  void gotoEditAdopter(UserProfile adopter)async {
  
        await _navigationService.pushModalBottom(Routes.adopter_edit_modal,
          data: AdopterEditModal(user:adopter));
      
  }
 Future<void> deleteAdopter(String userId) async {
   try{
    loading(true,loadingText: "Deleting User");
    bool res=await _dialogService.showAlertDialog(Message(description:"Do you Really want to delete User ?"));
   if(res)
   {
   var resDelete= await _apiService.deleteAdopter(SingleUser(userId:userId) );
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

  void updatAdopter(String name, String location,UserProfile user)async {

   try{
    
    loading(true);
     var updateUserRes=await _apiService.updateAdopter(
      UserProfile(adopterId: user.adopterId,name: user.name,location: location,isActive: isActive)
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
  


 
}
