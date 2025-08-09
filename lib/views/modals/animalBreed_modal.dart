// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import '../../helpers/locator.dart';
import '../../models/request_models/animal_breed.dart';
import '../../services/api_service.dart';
import '../../services/dialog_service.dart';

class AnimalbreedModal extends StatefulWidget {
  final String petId;
  const AnimalbreedModal({super.key, required this.petId});

  @override
  State<AnimalbreedModal> createState() => _AnimalbreedModalState();
}

class _AnimalbreedModalState extends State<AnimalbreedModal> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController petController;

  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    petController = TextEditingController();
  }

  @override
  void dispose() {
    petController.dispose();
    super.dispose();
  }

  Future<void> _handleAddAnimalBreed() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var addAnimalRes = await _apiService.addAnimalBreed(
        AddAnimalBreed(name: petController.text.trim(), animalId: widget.petId),
      );

      if (addAnimalRes.errorCode == "PA0004") {
        await _dialogService.showSuccess(text: "Animal Added Successfully");
        petController.clear();
      } else {
        await _dialogService.showGlassyErrorDialog(
            "This Breed Has Already Been Added: ${petController.text}");
      }
    } catch (e) {
      await _dialogService
          .showGlassyErrorDialog("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            // Form content with SafeArea
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add New Animal Breed",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 146, 61, 5),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: formKey,
                        child: DefaultTextInput(
                          controller: petController,
                          hintText: "Animal Breed",
                          icon: Icons.pets_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Add Animal Breed';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: _isLoading ? null : _handleAddAnimalBreed,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Center(
                                        child: FadingCircularDots(
                                      count: 10,
                                      radius: 20,
                                      dotRadius: 4,
                                      duration: Duration(milliseconds: 1200),
                                    )),
                                  ))
                              : const Text(
                                  "Add Animal Breed",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
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
}
