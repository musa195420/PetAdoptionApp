// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/viewModel/admin_view_models/donor_admin_view_model.dart';
import '../../../custom_widgets/default_text_input.dart';
import '../../../helpers/locator.dart';
import '../../../models/response_models/user_profile.dart';
import '../../../services/api_service.dart';
import 'package:provider/provider.dart';

class DonorEditModal extends StatefulWidget {
  final UserProfile user;
  const DonorEditModal({super.key, required this.user});

  @override
  State<DonorEditModal> createState() => _DonorEditModalState();
}

class _DonorEditModalState extends State<DonorEditModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController nameController;
  late TextEditingController locationController;

  // ignore: unused_element
  IAPIService get _apiService => locator<IAPIService>();

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<DonorAdminViewModel>();

    nameController = TextEditingController(text: widget.user.name);
    locationController = TextEditingController(text: widget.user.location);

    viewModel.isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DonorAdminViewModel>();

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
           Text(
            "Adopter Edit Page",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 30,
                fontWeight: FontWeight.w700),
          ),
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
                      padding: EdgeInsets.all(10),
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
                          _buildUpdateDonor(viewModel),
                          const SizedBox(height: 10),
                              _buildLiveStatusButton(viewModel), 
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                viewModel.updateDonor(
                                  nameController.text,
                                  locationController.text,
                                 widget.user
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildUpdateDonorButton(),
                            ),
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

  Widget _buildLiveStatusButton(DonorAdminViewModel viewModel) {
 bool isActive = viewModel.isActive;

  return GestureDetector(
    onTap: () {
      viewModel.setisActive(!isActive);
    },
    child: Container(
      padding: const EdgeInsets.all(3),
      width: 150,
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.green.withOpacity(0.3)
            : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: isActive 
            ? Colors.green
            : Colors.red,
        )
      ),
      child: Center(
        child: Text(
          isActive ? "Live" : "Not Live",
          style:  TextStyle(
            color:isActive 
            ? Colors.green
            : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildUpdateDonor(DonorAdminViewModel viewModel) {
    return Form(
      key: formKey,

      child: Column(
      spacing: 5,
        children: [
          const SizedBox(height: 15),
          DefaultTextInput(
            controller: nameController,
            hintText: "Name",
            icon: Icons.person_2_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Name Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: locationController,
            hintText: "Location",
            icon: Icons.location_history,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Location Please';
              }
              return null;
            },
          ),
         
        ],
      ),
    );
  }

  

  Widget _buildUpdateDonorButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: const Text(
        "Update Donor",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
