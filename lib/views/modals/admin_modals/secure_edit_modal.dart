// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/admin_view_models/secureMeetup_admin_view_model.dart';

TextEditingController phoneNumberController = TextEditingController();
TextEditingController currentAddressController = TextEditingController();
TextEditingController meetupIdController = TextEditingController();
TextEditingController rejectionReasonController = TextEditingController();

class SecureEdit extends StatelessWidget {
  final SecureMeetup meetup;
  SecureEdit({
    super.key,
    required this.meetup,
  });
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SecureMeetupAdminViewModel viewModel =
        context.watch<SecureMeetupAdminViewModel>();
    viewModel.setSecureMeetup(meetup);
    phoneNumberController =
        TextEditingController(text: viewModel.meetup!.phoneNumber ?? "");
    currentAddressController =
        TextEditingController(text: viewModel.meetup!.currentAddress ?? "");
    meetupIdController =
        TextEditingController(text: viewModel.meetup!.meetupId ?? "");
    rejectionReasonController =
        TextEditingController(text: viewModel.meetup!.rejectionReason ?? "");

    return StatefulWrapper(
      onInit: () {
        // viewModel.isApproved = meetup.isApproved ?? "Pending";
      },
      onDispose: () {
        meetupIdController.dispose();
        phoneNumberController.dispose();
        currentAddressController.dispose();
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
                                    _buildCharacterImage(
                                        viewModel,
                                        viewModel.proofPicPath,
                                        meetup.proofPicUrl,
                                        "proofPicPath",
                                        "Proof Picture"),
                                    _buildCharacterImage(
                                        viewModel,
                                        viewModel.adopterIdPath,
                                        meetup.adopterIdFrontUrl,
                                        "adopterIdPath",
                                        "Adopter Front Identity"),
                                    _buildCharacterImage(
                                        viewModel,
                                        viewModel.adopterIdBackPath,
                                        meetup.adopterIdBackUrl,
                                        "adopterIdBackPath",
                                        "Adopter Back Identity"),
                                    _buildUpdateSecure(viewModel),
                                  ],
                                )),
                            _buildAdminEdit(viewModel),
                            const SizedBox(height: 10),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  viewModel.updateSecureMeetup(
                                      phoneNumberController.text,
                                      currentAddressController.text,
                                      rejectionReasonController.text,
                                      viewModel.meetup!);
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

  Widget _buildUpdateSecure(SecureMeetupAdminViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 15),
          DefaultTextInput(
            controller: meetupIdController,
            labelText: "MeetupId",
            hintText: "MeetupId",
            enabled: viewModel.isEdit,
            readOnly: true,
            icon: Icons.pets_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter YourMeetupId Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: currentAddressController,
            hintText: "Current Address",
            labelText: "Current Address",
            enabled: viewModel.isEdit,
            icon: Icons.animation_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Current Address Of Adopter Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: phoneNumberController,
            readOnly: true,
            hintText: "Phone",
            labelText: "Phone",
            enabled: viewModel.isEdit,
            keyboardType: TextInputType.phone,
            icon: Icons.mobile_friendly,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Adopter Phone Number Please';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage(SecureMeetupAdminViewModel viewModel,
      String? path, String? url, String type, String heading) {
    return Column(
      spacing: 5,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: viewModel.isEdit
                ? const Color.fromARGB(255, 146, 61, 5)
                : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_3_rounded,
                color: Colors.white,
                size: 30,
              ),
              Text(
                heading,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

// ...

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
          child: path != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(path),
                    height: 150,
                    width: 530,
                    fit: BoxFit.cover,
                  ),
                )
              : url != null && url.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        height: 150,
                        width: 530,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          height: 150,
                          width: 530,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/signup.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
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
                    ? (path != null ? Colors.brown : Colors.deepOrange)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () async {
                  if (viewModel.isEdit) {
                    await viewModel.savePetImagePath(type);
                  }
                },
                child: Text(
                  path != null || path != null ? "Change Image" : "Add Image",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (path != null)
              GestureDetector(
                onTap: () {
                  if (viewModel.isEdit) {
                    viewModel.removeImagePath(type);
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

  Widget _buildAdminEdit(SecureMeetupAdminViewModel viewModel) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Admin Section",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                InkWell(
                    onTap: () async {
                      await viewModel.getMeetup(meetup.meetupId ?? "");
                    },
                    child: Icon(
                      Icons.link_rounded,
                      color: Colors.blue,
                      size: 24,
                    )),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => viewModel.getisApproved(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: viewModel
                            .getColor(viewModel.meetup!.approval ?? ""),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          viewModel.meetup!.approval ?? "",
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

            DefaultTextInput(
              controller: rejectionReasonController,
              hintText: "Rejection Reason",
              labelText: "Rejection Reason",
              keyboardType: TextInputType.phone,
              icon: Icons.cancel_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
