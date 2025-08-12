// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/loading_indicators.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/helpers/colors.dart';
import 'package:petadoption/models/response_models/secure_meetup.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/admin_view_models/secureMeetup_admin_view_model.dart';

class SecureEdit extends StatefulWidget {
  final SecureMeetup meetup;
  const SecureEdit({super.key, required this.meetup});

  @override
  State<SecureEdit> createState() => _SecureEditState();
}

class _SecureEditState extends State<SecureEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController phoneNumberController;
  late TextEditingController currentAddressController;
  late TextEditingController meetupIdController;
  late TextEditingController rejectionReasonController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SecureMeetupAdminViewModel>();
    viewModel.setSecureMeetup(widget.meetup);

    phoneNumberController =
        TextEditingController(text: widget.meetup.phoneNumber ?? "");
    currentAddressController =
        TextEditingController(text: widget.meetup.currentAddress ?? "");
    meetupIdController =
        TextEditingController(text: widget.meetup.meetupId ?? "");
    rejectionReasonController =
        TextEditingController(text: widget.meetup.rejectionReason ?? "");
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    currentAddressController.dispose();
    meetupIdController.dispose();
    rejectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecureMeetupAdminViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF4F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              _buildHeader(viewModel),
              _buildCharacterImage(
                viewModel,
                viewModel.proofPicPath,
                widget.meetup.proofPicUrl,
                'assets/images/donor.png',
                "proofPicPath",
                Icons.verified_user,
                "Proof Picture — Upload a photo of the pet with the adopter",
              ),
              _buildCharacterImage(
                viewModel,
                viewModel.adopterIdPath,
                widget.meetup.adopterIdFrontUrl,
                'assets/images/user_verif.png',
                "adopterIdPath",
                Icons.credit_card,
                "Adopter Front CNIC Card",
              ),
              _buildCharacterImage(
                viewModel,
                viewModel.adopterIdBackPath,
                widget.meetup.adopterIdBackUrl,
                'assets/images/user_verif.png',
                "adopterIdBackPath",
                Icons.credit_card_outlined,
                "Adopter Back CNIC Card",
              ),
              _buildUpdateForm(viewModel),
              const SizedBox(height: 10),
              _buildUpdateButton(viewModel),
              if (viewModel.isAdmin()) _buildAdminEdit(viewModel)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SecureMeetupAdminViewModel viewModel) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        GestureDetector(
          onTap: viewModel.setEdit,
          child: Icon(
            Icons.edit,
            size: 30,
            color: viewModel.isEdit ? Colors.brown : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterImage(
    SecureMeetupAdminViewModel viewModel,
    String? path,
    String? url,
    String defaultImage,
    String type,
    IconData icon,
    String heading,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.brown, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: path != null
                  ? Image.file(File(path),
                      height: 150, width: double.infinity, fit: BoxFit.cover)
                  : (url != null && url.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: url,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, _) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (_, __, ___) => Image.asset(
                            defaultImage,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(
                          defaultImage,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: viewModel.isEdit
                    ? () => viewModel.savePetImagePath(type)
                    : null,
                icon: const Icon(Icons.upload_file),
                label: Text(path != null ? "Change Image" : "Upload Image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
              ),
              if (path != null) ...[
                const SizedBox(width: 10),
                IconButton(
                  onPressed: viewModel.isEdit
                      ? () => viewModel.removeImagePath(type)
                      : null,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUpdateForm(SecureMeetupAdminViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          DefaultTextInput(
            controller: meetupIdController,
            labelText: "Meetup ID",
            hintText: "Auto-generated ID",
            readOnly: true,
            icon: Icons.pets,
          ),
          DefaultTextInput(
            controller: currentAddressController,
            labelText: "Current Address",
            hintText: "Enter adopter's current address",
            enabled: viewModel.isEdit,
            icon: Icons.home,
            validator: (value) =>
                value!.isEmpty ? "Please enter current address" : null,
          ),
          DefaultTextInput(
            controller: phoneNumberController,
            labelText: "Phone Number",
            hintText: "Enter adopter's phone number",
            enabled: viewModel.isEdit,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value!.isEmpty ? "Please enter phone number" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(SecureMeetupAdminViewModel viewModel) {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          viewModel.updateSecureMeetup(
            phoneNumberController.text,
            currentAddressController.text,
            rejectionReasonController.text,
            viewModel.meetup!,
          );
        }
      },
      icon: const Icon(Icons.save),
      label: const Text("Update Status"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      await viewModel.getMeetup(widget.meetup.meetupId ?? "");
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
