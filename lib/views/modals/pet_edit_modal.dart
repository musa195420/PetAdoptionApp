import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/viewModel/admin_view_models/pet_admin_view_model.dart';
import 'package:petadoption/views/pet_page.dart';
import 'package:provider/provider.dart';

TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController breedController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController rejectionReason = TextEditingController();

class PetEditModal extends StatelessWidget {
  final PetResponse pet;
  PetEditModal({
    super.key,
    required this.pet,
  });
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PetAdminViewModel viewModel = context.watch<PetAdminViewModel>();

    viewModel.setPet(pet);
    breedController = TextEditingController(text: viewModel.pet!.breed);
    animalTypeController = TextEditingController(text: viewModel.pet!.animal);
    genderController = TextEditingController(text: pet.gender);

    nameController = TextEditingController(text: pet.name);
    ageController = TextEditingController(text: pet.age.toString());
    descriptionController = TextEditingController(text: pet.description);
    rejectionReason = TextEditingController(text: pet.rejectionReason);
    viewModel.setPet(pet);
    return StatefulWrapper(
      onInit: () {
        viewModel.isApproved = pet.isApproved ?? "Pending";
      },
      onDispose: () {
        nameController.dispose();
        ageController.dispose();
        breedController.dispose();
        genderController.dispose();
        descriptionController.dispose();
        rejectionReason.dispose();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 247, 240),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 3,
                                      color: viewModel.isEdit
                                          ? Colors.redAccent
                                          : Colors.grey),
                                ),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              viewModel.setEdit();
                                            },
                                            child: Icon(
                                              Icons.edit_document,
                                              size: 30,
                                              color: viewModel.isEdit
                                                  ? Colors.deepOrange
                                                  : Colors.grey,
                                            )),
                                      ],
                                    ),
                                    _buildCharacterImage(viewModel),
                                    _buildUpdatePet(viewModel),
                                  ],
                                )),
                            _buildAdminEdit(viewModel),
                            const SizedBox(height: 10),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  viewModel.updatePet(nameController.text,int.parse(ageController.text),descriptionController.text,rejectionReason.text);
                                }
                              },
                              child: _buildUpdateStatusButton(),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildUpdatePet(PetAdminViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 15),
          DefaultTextInput(
            controller: nameController,
            labelText: "Name",
            hintText: "Name",
            enabled: viewModel.isEdit,
            icon: Icons.pets_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Name Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: animalTypeController,
            hintText: "Animal Type",
            labelText: "Animal Type",
            readOnly: true,
            enabled: viewModel.isEdit,
            onTap: () {
              viewModel.getAnimalType();
            },
            icon: Icons.animation_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Pets Type Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: breedController,
            readOnly: true,
            hintText: "Breed",
            labelText: "Breed",
            enabled: viewModel.isEdit,
            onTap: () {
              viewModel.getBreeds();
            },
            icon: Icons.type_specimen,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Pets Breed Please';
              }

              return null;
            },
          ),
          DefaultTextInput(
            controller: ageController,
            labelText: "Age ",
            hintText: "Age ",
            enabled: viewModel.isEdit,
            keyboardType: TextInputType.number,
            icon: Icons.line_weight_sharp,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Pets Age Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: genderController,
            labelText: "Gender",
            hintText: "Gender",
            enabled: viewModel.isEdit,
            readOnly: true,
            keyboardType: TextInputType.number,
            icon: Icons.g_mobiledata,
            onTap: () {
              viewModel.getGender();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Pets Age Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: descriptionController,
            hintText: "Description",
            labelText: "Description",
            enabled: viewModel.isEdit,
            icon: Icons.description,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Pets Description Please';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage(PetAdminViewModel viewModel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
            color: viewModel.isEdit ? Colors.white : Colors.grey,
            border: Border.all(
              color: const Color.fromARGB(255, 255, 247, 240),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: viewModel.path != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(viewModel.path!),
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                )
              : pet.image != null && pet.image!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        pet.image!,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/signup.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: viewModel.isEdit
                    ? (viewModel.path != null
                        ? Colors.brown
                        : Colors.deepOrange)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () async {
                  if (viewModel.isEdit) {
                    await viewModel.savePetImagePath();
                  }
                },
                child: Text(
                  viewModel.path != null || pet.image != null
                      ? "Change Image"
                      : "Add Image",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (viewModel.path != null)
              GestureDetector(
                onTap: () {
                  if (viewModel.isEdit) {
                    viewModel.removeImagePath();
                  }
                },
                child: Icon(
                  Icons.delete,
                  color: viewModel.isEdit ? Colors.deepOrange : Colors.grey,
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildUpdateStatusButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: const Text(
        "Update Status",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

Widget _buildAdminEdit(PetAdminViewModel viewModel) {
  String displayText = pet.isLive.toString() == 'true' ? "Live" : "Not Live";
  Color liveColor = pet.isLive.toString() == 'true' ? Colors.green : Colors.red;

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Section Title
          Text(
            "Admin Section",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade700,
            ),
          ),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => viewModel.isLive(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: liveColor.withOpacity(0.1),
                      border: Border.all(color: liveColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        displayText,
                        style: TextStyle(
                          color: liveColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => viewModel.getisApproved(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: viewModel.getColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        viewModel.isApproved,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // More Info Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                viewModel.userInfo(pet.donorId);
              },
              child: Text(
                "User  Information",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Rejection Reason Input
          DefaultTextInput(
            controller: rejectionReason,
            hintText: "Enter reason for rejection",
            labelText: "Rejection Reason",
            icon: Icons.cancel_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter rejection reason';
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );
}

}
