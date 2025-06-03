// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/health_info.dart';
import 'package:petadoption/viewModel/pet_view_model.dart';

import 'package:provider/provider.dart';

import '../../../custom_widgets/default_text_input.dart';

class HealthInfoModal extends StatelessWidget {
  dynamic formKey = GlobalKey<FormState>();

  final PetHealthInfo info;
  HealthInfoModal({super.key, required this.info});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PetViewModel viewModel = context.watch<PetViewModel>();

    return StatefulWrapper(
      onDispose: () {},
      onInit: () async {
        await viewModel.setFields(info);
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
                            viewModel.isHealthInfoReady
                                ? _buildAddHealthtForm(viewModel)
                                : const CircularProgressIndicator(), // or a shimmer/loading UI
                            const SizedBox(height: 10),
                            viewModel.isHealthInfoReady
                                ? InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        viewModel.updateHealthInfo(
                                            info.petId, info.healthId ?? "");
                                      }
                                    },
                                    child: _buildupdateHealth(viewModel),
                                  )
                                : SizedBox.shrink(),
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
                  controller: viewModel.diseaseController,
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
                  controller: viewModel.disabilityController,
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
                  controller: viewModel.vaccinationController,
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

  Widget _buildupdateHealth(PetViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: Text(
        "Update Health",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
