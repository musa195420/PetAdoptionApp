import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/message.dart';
import 'package:petadoption/models/request_models/single_pet.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/models/response_models/user_profile.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
class PetAdminViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
 String ?path;
  List<PetResponse>? pets;
  List<PetResponse>? filteredPets;
void removeImagePath()
{
  path=null;
  notifyListeners();
}



  Future<void> updatepetImage(String petId) async {
    if (path != null) {
      final status = await _apiService.uploadPetImage(path!, petId);
      if (status.data != null) {
        debugPrint("Upload success: ${status.data}");
      } else {
        debugPrint("Upload failed: ${status.errorCode}");
      }
    }
  }

 Future<void> savePetImagePath() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    path = pickedFile.path;

    notifyListeners();
  }
bool isActive=false;

void setisActive(bool isActive)
{
 this.isActive=isActive;
  notifyListeners();
}




  Future<void> getPets() async {
    try {
      loading(true);
      var petRes = await _apiService.getPets();

      if (petRes.errorCode == "PA0004") {
        pets = (petRes.data as List)
            .map((json) => PetResponse.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredPets = List.from(pets!);
      } else {
        await _dialogService.showApiError(
          petRes.data.status.toString(),
          petRes.data.message.toString(),
          petRes.data.error.toString(),
        );
      }
    } catch (e, s) {
      _globalService.logError("Error Occured When Renew User Token", e.toString(), s);
    } finally {
      notifyListeners();
      loading(false);
    }
  }

  void filterPets(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredPets = List.from(pets ?? []);
    } else {
      filteredPets = pets
          ?.where((u) => u.userEmail!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredPets = List.from(pets ?? []);
    notifyListeners();
  }

  

  void gotoEditPet(PetResponse adopter)async {
  
        // await _navigationService.pushModalBottom(Routes.donor_edit_modal,
        //   data:DonorEditModal(user:adopter));
      
  }
 Future<void> deletePet(String petId) async {
   try{
    loading(true,loadingText: "Deleting Pet");
    bool res=await _dialogService.showAlertDialog(Message(description:"Do you Really want to delete Pet ?"));
   if(res)
   {
   var resDelete= await _apiService.deletePet(SinglePet(petId: petId) );
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

  void updatePet(String petId,String donorId,String name, String animalId,String breedId,int age,String gender,String description,String isApproved,String? rejectionReason,bool isLive)async {

   try{
    
    loading(true);
     var updatePetrRes=await _apiService.updatePet(
    PetResponse(petId: petId, donorId: donorId, breedId: breedId, animalId: animalId)
    );

    if(updatePetrRes.errorCode=="PA0004")
    {
      debugPrint("User Updated Success Fully");
      
    }
    else{
      await _dialogService.showApiError(
                updatePetrRes.data.status.toString(),
                updatePetrRes.data.message.toString(),
                updatePetrRes.data.error.toString());

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
