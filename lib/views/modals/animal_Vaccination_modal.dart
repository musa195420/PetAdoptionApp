// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/extenshions/string_ext.dart';
import 'package:petadoption/models/request_models/add_bulk.dart';
import 'package:petadoption/services/dialog_service.dart';
import '../../helpers/locator.dart';
import '../../services/api_service.dart';

dynamic formKey = GlobalKey<FormState>();

class AnimalVaccinationModal extends StatelessWidget {
  final String animalId;
  AnimalVaccinationModal({super.key, required this.animalId});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      _buildForm(),
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

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          Text(
            "Add New Vaccination",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 24,
                fontWeight: FontWeight.w700),
          ),
          DefaultTextInput(
            controller: petController,
            hintText: "Animal Vaccination",
            icon: Icons.pets_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Add Animal Vaccination';
              }
              return null;
            },
          ),
          _buildButton(animalId),
        ],
      ),
    );
  }

  Widget _buildButton(String animalId) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.brown,
      ),
      child: GestureDetector(
        child: Text(
          "Add Animal Vaccination",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () async {
          if (formKey.currentState!.validate()) {
            var addAnimalRes = await _apiService.addVaccine(AddInBulk(
                name: petController.text.toString().toTitleCase(),
                animalId: animalId));

            if (addAnimalRes.errorCode == "PA0004") {
              await _dialogService.showSuccess(
                  text: "Vaccination Added SucessFully");
            }
          }
        },
      ),
    );
  }
}
