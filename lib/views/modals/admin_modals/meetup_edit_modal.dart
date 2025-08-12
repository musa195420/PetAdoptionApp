// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/meetup.dart';
import 'package:provider/provider.dart';

import '../../../viewModel/admin_view_models/secureMeetup_admin_view_model.dart';

class MeetupEdit extends StatefulWidget {
  final Meetup meetup;
  const MeetupEdit({super.key, required this.meetup});

  @override
  State<MeetupEdit> createState() => _MeetupEditState();
}

class _MeetupEditState extends State<MeetupEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController locationController;
  late TextEditingController adopterController;
  late TextEditingController donorController;
  late TextEditingController petController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SecureMeetupAdminViewModel>();
    viewModel.setMeetup(widget.meetup);

    locationController =
        TextEditingController(text: viewModel.meets?.location ?? "");
    adopterController =
        TextEditingController(text: widget.meetup.adopterEmail ?? "");
    donorController =
        TextEditingController(text: widget.meetup.donorEmail ?? "");
    petController = TextEditingController(text: viewModel.meets?.petName ?? "");
  }

  @override
  void dispose() {
    locationController.dispose();
    adopterController.dispose();
    donorController.dispose();
    petController.dispose();
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
            spacing: 20,
            children: [
              _buildHeader(viewModel),
              _buildUpdateForm(viewModel),
              _buildStatusBoxes(viewModel),
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
        const Text(
          "Meetup Information",
          style: TextStyle(
            color: Color(0xFF923D05),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: viewModel.setEdit,
          child: Icon(
            Icons.edit,
            size: 26,
            color: viewModel.isEdit ? Colors.deepOrange : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateForm(SecureMeetupAdminViewModel viewModel) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 12,
            children: [
              _buildTextWithLink(
                controller: petController,
                label: "Pet Name",
                icon: Icons.pets_outlined,
                enabled: viewModel.isEdit,
                onTap: () {
                  if (viewModel.isEdit) {
                    viewModel.showPetInfo(viewModel.meets!.petId);
                  }
                },
              ),
              _buildTextWithLink(
                controller: donorController,
                label: "Donor Name",
                icon: Icons.volunteer_activism,
                enabled: viewModel.isEdit,
                onTap: () {
                  if (viewModel.isEdit) {
                    viewModel.getUserInfo(viewModel.meets!.donorId!);
                  }
                },
              ),
              _buildTextWithLink(
                controller: adopterController,
                label: "Adopter Name",
                icon: Icons.person,
                enabled: viewModel.isEdit,
                onTap: () {
                  if (viewModel.isEdit) {
                    viewModel.getUserInfo(viewModel.meets!.adopterId!);
                  }
                },
              ),
              DefaultTextInput(
                controller: locationController,
                labelText: "Meetup Location",
                hintText: "Enter meetup location",
                icon: Icons.location_on,
                enabled: viewModel.isEdit,
                validator: (value) =>
                    value!.isEmpty ? "Please enter location" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextWithLink({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextInput(
            controller: controller,
            labelText: label,
            hintText: label,
            icon: icon,
            enabled: enabled,
            validator: (value) => value!.isEmpty ? "Please enter $label" : null,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: enabled ? Colors.brown : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.link, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBoxes(SecureMeetupAdminViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _statusTile(
            title: "Adopter",
            isAccepted: viewModel.meets?.isAcceptedByAdopter ?? false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statusTile(
            title: "Donor",
            isAccepted: viewModel.meets?.isAcceptedByDonor ?? false,
          ),
        ),
      ],
    );
  }

  Widget _statusTile({required String title, required bool isAccepted}) {
    final Color statusColor = isAccepted ? Colors.green : Colors.red;
    final IconData statusIcon = isAccepted ? Icons.check_circle : Icons.cancel;
    final String statusText = isAccepted ? "Accepted" : "Rejected";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Icon(statusIcon, color: statusColor, size: 36),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
