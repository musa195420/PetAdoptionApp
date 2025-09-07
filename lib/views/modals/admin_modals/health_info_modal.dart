// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
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

  // Color palette
  final Color darkBrown = const Color(0xFF4E342E);
  final Color lightBrown = const Color(0xFFD7CCC8);
  final Color grey = const Color(0xFFE0E0E0);
  final Color white = Colors.white;

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
        backgroundColor: lightBrown,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 20,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: darkBrown,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.health_and_safety,
                          color: Colors.white, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "Health Info Page",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/health_info.png",
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),

                // Main card
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 15,
                    children: [
                      viewModel.isHealthInfoReady
                          ? _buildAddHealthtForm(viewModel)
                          : const SizedBox(
                              height: 80,
                              child: Center(
                                  child: FadingCircularDots(
                                count: 10,
                                radius: 20,
                                dotRadius: 4,
                                duration: Duration(milliseconds: 1200),
                              )),
                            ),
                      if (viewModel.isHealthInfoReady && !info.isViewer)
                        _buildupdateHealth(viewModel),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddHealthtForm(PetViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          _buildRowWithAddButton(
            controller: viewModel.diseaseController,
            label: "Disease",
            hint: "Disease",
            icon: Icons.coronavirus,
            onTapField: () {
              if (!info.isViewer) {
                viewModel.getAnimalDiseases(info.animalId);
              }
            },
            onTapAdd: () => viewModel.addDisease(info.animalId!),
          ),
          _buildRowWithAddButton(
            controller: viewModel.disabilityController,
            label: "Disability",
            hint: "Disability",
            icon: Icons.accessible,
            onTapField: () {
              if (!info.isViewer) {
                viewModel.getAnimalDisability(info.animalId);
              }
            },
            onTapAdd: () => viewModel.addDisability(info.animalId!),
          ),
          _buildRowWithAddButton(
            controller: viewModel.vaccinationController,
            label: "Vaccination",
            hint: "Vaccination",
            icon: Icons.vaccines,
            onTapField: () {
              if (!info.isViewer) {
                viewModel.getAnimalVaccination(info.animalId);
              }
            },
            onTapAdd: () => viewModel.addVaccination(info.animalId!),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithAddButton({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required VoidCallback onTapField,
    required VoidCallback onTapAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextInput(
            controller: controller,
            hintText: hint,
            labelText: label,
            readOnly: true,
            onTap: onTapField,
            icon: icon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onTapAdd,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkBrown,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildupdateHealth(PetViewModel viewModel) {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          viewModel.updateHealthInfo(info.petId, info.healthId ?? "");
        }
      },
      icon: const Icon(Icons.update, color: Colors.white),
      label: const Text(
        "Update Health",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBrown,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
    );
  }
}
