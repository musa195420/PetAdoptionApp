// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/admin_view_models/secureMeetup_admin_view_model.dart';

TextEditingController locationController = TextEditingController();
TextEditingController adopterController = TextEditingController();
TextEditingController donorController = TextEditingController();
TextEditingController petController = TextEditingController();

class MeetupEdit extends StatelessWidget {
  final Meetup meetup;
  MeetupEdit({
    super.key,
    required this.meetup,
  });
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SecuremeetupAdminViewModel viewModel =
        context.watch<SecuremeetupAdminViewModel>();
    viewModel.setMeetup(meetup);
    locationController =
        TextEditingController(text: viewModel.meets!.location ?? "");
    adopterController =
        TextEditingController(text: viewModel.meets!.adopterName ?? "");
    donorController =
        TextEditingController(text: viewModel.meets!.donorName ?? "");
    petController = TextEditingController(text: viewModel.meets!.petName ?? "");

    return StatefulWrapper(
      onInit: () {
        // viewModel.isApproved = meetup.isApproved ?? "Pending";
      },
      onDispose: () {
        petController.dispose();
        locationController.dispose();
        adopterController.dispose();
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
                      Text(
                        "Meetup Information",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 146, 61, 5),
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
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
                                    _buildUpdateSecure(viewModel),
                                  ],
                                )),
                            _buildbox(viewModel),
                            const SizedBox(height: 10),
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

  Widget _buildbox(SecuremeetupAdminViewModel viewModel) {
    final bool isAdopterAccepted =
        viewModel.meets!.isAcceptedByAdopter ?? false;
    final bool isDonorAccepted = viewModel.meets!.isAcceptedByDonor ?? false;

    Widget buildStatusTile({required bool isAccepted, required String title}) {
      final Color statusColor = isAccepted ? Colors.green : Colors.red;
      final IconData statusIcon =
          isAccepted ? Icons.check_circle : Icons.cancel;
      final String statusText = isAccepted ? "Accepted" : "Rejected";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              border: Border.all(color: statusColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 36),
                const SizedBox(height: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: buildStatusTile(
              isAccepted: isAdopterAccepted,
              title: "Adopter",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildStatusTile(
              isAccepted: isDonorAccepted,
              title: "Donor",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateSecure(SecuremeetupAdminViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: petController,
                  labelText: "Pet Name",
                  hintText: "Pet Name",
                  enabled: viewModel.isEdit,
                  icon: Icons.pets_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Pet Name Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  if (viewModel.isEdit) {
                    viewModel.showPetInfo(viewModel.meets!.petId);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: viewModel.isEdit ? Colors.brown : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.insert_link,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: donorController,
                  labelText: "Donor Name",
                  hintText: "Donor Name",
                  enabled: viewModel.isEdit,
                  icon: Icons.pets_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Your Donor Name Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  if (viewModel.isEdit) {
                    viewModel.getUserInfo(viewModel.meets!.donorId!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: viewModel.isEdit ? Colors.brown : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.insert_link,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DefaultTextInput(
                  controller: adopterController,
                  hintText: "Adopter Name",
                  labelText: "Adopter Name",
                  enabled: viewModel.isEdit,
                  icon: Icons.animation_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Adopter Name Please';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  if (viewModel.isEdit) {
                    viewModel.getUserInfo(viewModel.meets!.adopterId!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: viewModel.isEdit ? Colors.brown : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.insert_link,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          DefaultTextInput(
            controller: locationController,
            readOnly: true,
            hintText: "Meetup Location",
            labelText: "Meetup Location",
            enabled: viewModel.isEdit,
            icon: Icons.mobile_friendly,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Meetup Location Please';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
