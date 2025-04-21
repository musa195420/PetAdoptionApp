import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import '../../helpers/locator.dart';
import '../../models/hive_models/user.dart';
import '../../models/request_models/animalType_request.dart';
import '../../models/response_models/pet_response.dart';
import '../../models/response_models/user_profile.dart';
import '../../services/api_service.dart';

dynamic formKey = GlobalKey<FormState>();

class UserLinkModal extends StatelessWidget {
  final UserProfile? userProfile;
  List<PetResponse>? pets;
  final User user;
  UserLinkModal({super.key, this.userProfile, required this.user, this.pets});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IAPIService get _apiService => locator<IAPIService>();
  final TextEditingController petController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {},
      onDispose: () {
        petController.dispose();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            // Login form content with SafeArea
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 247, 240),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20,
                      20), // top padding gives space for character image
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
            "User Information",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
                      _showUser(),
                      if (pets != null && pets!.isNotEmpty) _showPet(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showUser() {
    return Container(
      width: double.infinity,
     
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
         color: Colors.white,
        border: Border.all(width: 1, color: Colors.brown),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 3,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: user.profileImage != null
                    ? Image.network(
                        user.profileImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/noprofile.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/noprofile.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),
          if (userProfile != null)
            Column(
              children: [
                Divider(),
                _row("Name", userProfile!.name),
                Divider(),
                _row("Location", userProfile!.location),
                 Divider(),
                _row("Is Active", userProfile!.isActive.toString()),
              ],
            ),
          Divider(),
          _row("Email", user.email),
          Divider(),
          _row("phoneNumber", user.phoneNumber),
          Divider(),
          _row("Role", user.role),
          Divider(),
          _row("Device ID", user.deviceId),
           Divider(),
          
        ],
      ),
    );
  }

  Widget _showPet() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: ListView.builder(
        shrinkWrap:
            true, // To prevent the list from expanding beyond the screen
        itemCount: pets!.length, // Number of pets
        itemBuilder: (context, index) {
          return Column(
            spacing: 3,
            children: [
                 Text(
            "Pet (${index+1}) Information",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10), // Adds space between pet boxes
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Colors.brown), // Box border for each pet
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white, // Background color for each box
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: pets![index].image != null
                              ? Image.network(
                                  pets![index].image!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/signup.png",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/images/signup.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                    Divider(),
                    _row("Name", pets![index].name ?? ""),
                    Divider(),
                    _row("Animal Type", pets![index].animal ?? ""),
                    Divider(),
                    _row("Breed", pets![index].breed ?? ""),
                    Divider(),
                    _row("Age", pets![index].age.toString()),
                    Divider(),
                    _row("Gender", pets![index].gender.toString()),
                    Divider(),
                    _row("Created At", pets![index].createdAt.toString()),
                    Divider(),
                    _row("Description", pets![index].description ?? ""),
                    Divider(),
                    _row("Approval Status", pets![index].isApproved ?? ""),
                    Divider(),
                    _row("Live Status", pets![index].isLive.toString()),
                    Divider(),
                    _row("Rejection Reason", pets![index].rejectionReason ?? ""),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the top
      children: [
        Expanded(
          child: Text(
            text1,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            text2,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            softWrap:
                true, // Ensures text wraps when it exceeds the available space
            overflow:
                TextOverflow.visible, // Allows the text to go to the next line
          ),
        ),
      ],
    );
  }
}
