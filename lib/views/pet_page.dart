import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petadoption/helpers/image_processor.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:provider/provider.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/services/navigation_service.dart';

final ImageProcessor _imageProcessor = ImageProcessor();

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  final GlobalKey<FormState> formKeypet = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService _navigationService = locator<NavigationService>();

  late TextEditingController nameController;

  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    _imageProcessor.init();
    breedController = TextEditingController();
    ageController = TextEditingController();
    genderController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();

    breedController.dispose();
    ageController.dispose();
    genderController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PetViewModel viewModel = context.watch<PetViewModel>();

    viewModel.animaltypeController.text =
        viewModel.selectedAnimalTypeName ?? "";
    breedController.text = viewModel.selectedBreedName ?? "";
    genderController.text = viewModel.gender;

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _navigationService.pop(),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF5D1F00),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => viewModel.loadModel(),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF5D1F00),
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildCharacterImage(viewModel),
                    Container(
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildAddPetForm(viewModel),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              if (formKeypet.currentState!.validate()) {
                                viewModel.addPet(
                                  nameController.text,
                                  int.parse(ageController.text),
                                  descriptionController.text,
                                );
                              }
                            },
                            child: _buildAddPetButton(),
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
    );
  }

  Widget _buildCharacterImage(PetViewModel viewModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color.fromARGB(255, 255, 247, 240),
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
                color: viewModel.path != null
                    ? Colors.brown
                    : const Color.fromARGB(255, 163, 49, 14),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: GestureDetector(
                onTap: () async {
                  await viewModel.savePetImagePath();
                },
                child: Text(
                  viewModel.path != null ? "Change Image" : "Add Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (viewModel.path != null)
              GestureDetector(
                onTap: () => viewModel.logout(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.delete, color: Colors.deepOrange),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddPetForm(PetViewModel viewModel) {
    return Form(
      key: formKeypet,
      child: Column(
        spacing: 5,
        children: [
          const SizedBox(height: 15),
          DefaultTextInput(
            controller: nameController,
            hintText: "Name",
            icon: Icons.pets,
            validator: (value) => value == null || value.isEmpty
                ? 'Enter Your Animal Name Please'
                : null,
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: viewModel.animaltypeController,
                  hintText: "Animal Type",
                  icon: Icons.animation,
                  readOnly: true,
                  onTap: () async {
                    await viewModel.getAnimalType();
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter Animal Type Please'
                      : null,
                ),
              ),
              const SizedBox(width: 5),
              _addIconButton(() => viewModel.addanimalType()),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: breedController,
                  hintText: "Breed Type",
                  icon: Icons.type_specimen,
                  readOnly: true,
                  onTap: () async =>
                      viewModel.getAnimalBreed(viewModel.selectedAnimalTypeId),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter Animal Breed Please'
                      : null,
                ),
              ),
              const SizedBox(width: 5),
              _addIconButton(() => viewModel.addanimalBreed()),
            ],
          ),
          DefaultTextInput(
            controller: ageController,
            keyboardType: TextInputType.number,
            hintText: "Age",
            icon: Icons.height,
            validator: (value) => value == null || value.isEmpty
                ? 'Enter Animal Age Please'
                : null,
          ),
          DefaultTextInput(
            controller: genderController,
            hintText: "Gender",
            icon: Icons.g_mobiledata,
            readOnly: true,
            onTap: () => viewModel.getGender(),
            validator: (value) => value == null || value.isEmpty
                ? 'Enter Animal Gender Please'
                : null,
          ),
          DefaultTextInput(
            controller: descriptionController,
            hintText: "Description",
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(255, 163, 49, 14),
      ),
      child: Text(
        "Add pet",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _addIconButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
