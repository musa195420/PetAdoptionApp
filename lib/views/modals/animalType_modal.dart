// ignore_for_file: unused_local_variable, file_names

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/extenshions/string_ext.dart';
import '../../helpers/locator.dart';
import '../../models/request_models/animalType_request.dart';
import '../../services/api_service.dart';
import '../../services/dialog_service.dart';

dynamic formKey = GlobalKey<FormState>();

late TextEditingController petController;
IAPIService get _apiService => locator<IAPIService>();
IDialogService get _dialogService => locator<IDialogService>();
final scaffoldKey = GlobalKey<ScaffoldState>();

class AnimaltypeModal extends StatefulWidget {
  const AnimaltypeModal({super.key});

  @override
  State<AnimaltypeModal> createState() => _AnimaltypeModalState();
}

class _AnimaltypeModalState extends State<AnimaltypeModal> {
  @override
  void initState() {
    petController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    petController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {},
      onDispose: () {},
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
                      _buildLoginForm(),
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

  Widget _buildLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          Text(
            "Add New Animal Type",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 24,
                fontWeight: FontWeight.w700),
          ),
          DefaultTextInput(
            controller: petController,
            hintText: "Animal Type",
            icon: Icons.pets_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Add Animal Type';
              }
              return null;
            },
          ),
          _buildAnimalTypeButton(),
        ],
      ),
    );
  }

  Widget _buildAnimalTypeButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.brown,
      ),
      child: GestureDetector(
        child: Text(
          "Add Animal Type",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () async {
          if (formKey.currentState!.validate()) {
            var addAnimalRes = await _apiService.addAnimalType(AddAnimalType(
                name: petController.text.toString().toTitleCase()));

            if (addAnimalRes.errorCode == "PA0004") {
              await _dialogService.showSuccess(
                  text: "Animal Added Successfully");
            } else {
              await _dialogService.showGlassyErrorDialog(
                  "This Type Has Been Already Added ${petController.text.toString()}");
            }
          }
        },
      ),
    );
  }
}
