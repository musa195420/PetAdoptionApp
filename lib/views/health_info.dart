// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';

import 'package:provider/provider.dart';

import '../custom_widgets/default_text_input.dart';
import '../models/health_info.dart';

class HealthInfo extends StatelessWidget {
  dynamic formKey = GlobalKey<FormState>();
  TextEditingController vaccinationController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController disabilityController = TextEditingController();
  final HealthInfoModel info;
  HealthInfo({super.key, required this.info});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PetViewModel viewModel = context.watch<PetViewModel>();
    vaccinationController =
        TextEditingController(text: viewModel.selectedVaccinationName);
    diseaseController =
        TextEditingController(text: viewModel.selectedDiseaseName);
    disabilityController =
        TextEditingController(text: viewModel.selectedDisabilityName);
    return StatefulWrapper(
      onDispose: () {
        disabilityController.dispose();
        vaccinationController.dispose();

        diseaseController.dispose();
      },
      onInit: () {},
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      // Character image at top, overlapping the container
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 146, 61, 5),
                        ),
                        child: Text(
                          "Health Info Page",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/health_info.png",
                          width: 150,
                          height: 150,
                        ),
                      ),

                      // Padding to make space for the image
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
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          children: [
                            _buildAddHealthtForm(viewModel),
                            const SizedBox(height: 10),
                            InkWell(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    viewModel.saveHealthInfo(info.petId);
                                  }
                                },
                                child: _buildAddPetButton(viewModel)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddHealthtForm(PetViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 10,
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: diseaseController,
                  hintText: "Disease",
                  labelText: "Disease",
                  readOnly: true,
                  onTap: () {
                    viewModel.getAnimalDiseases(info.animalId);
                  },
                  icon: Icons.pets,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Pets Disease Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  viewModel.addDisease(info.animalId!);
                },
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
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: disabilityController,
                  hintText: "Disability",
                  labelText: "Disability",
                  readOnly: true,
                  onTap: () {
                    viewModel.getAnimalDisability(info.animalId);
                  },
                  icon: Icons.pets,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Pets Disability Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  viewModel.addDisability(info.animalId!);
                },
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
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: vaccinationController,
                  hintText: "Vaccination",
                  labelText: "Vaccination",
                  readOnly: true,
                  onTap: () {
                    viewModel.getAnimalVaccination(info.animalId);
                  },
                  icon: Icons.pets,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Pets Vaccination Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  viewModel.addVaccination(info.animalId!);
                },
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetButton(PetViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: Text(
        "Confirm Health",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
