// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/models/response_models/pet_response.dart';
import 'package:petadoption/viewModel/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final Color primaryColor = const Color(0xFF3E2723);
  final Color accentColor = const Color.fromARGB(255, 83, 36, 6);
  final Color backgroundColor = const Color(0xFFFAF3E0);

  @override
  Widget build(BuildContext context) {
    ProfileViewModel viewModel = context.watch<ProfileViewModel>();

    return StatefulWrapper(
      onInit: () => viewModel.getUser(),
      onDispose: () {},
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: viewModel.user == null
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 20,
                    children: [
                      _profileHeader(viewModel),
                      updateInfo(viewModel, accentColor),
                      _buildInfoSection(viewModel),
                      _logoutButton(context, viewModel),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget updateInfo(ProfileViewModel viewModel, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Edit Button (Left)
        InkWell(
          onTap: () {
            viewModel.seteditMode(!viewModel.editMode);
          },
          child: Row(
            children: [
              Text(
                "Edit ",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.edit,
                size: 18,
                color: accentColor,
              ),
            ],
          ),
        ),

        // Update Button (Right)
        if (viewModel.editMode)
          InkWell(
            onTap: () async {
              await viewModel.updateUser();
            },
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 99, 34, 10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _profileHeader(ProfileViewModel viewModel) {
    final user = viewModel.user!;
    final profile = viewModel.userProfile;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: accentColor.withOpacity(0.1),
              backgroundImage: viewModel.path != null
                  ? FileImage(File(viewModel.path!))
                  : user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : const AssetImage('assets/images/noprofile.png'),
            ),
            if (viewModel.editMode)
              InkWell(
                onTap: () {
                  if (viewModel.path != null) {
                    viewModel.removeImagePath();
                  } else {
                    viewModel.saveImagePath();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: viewModel.path != null
                      ? Icon(Icons.delete, size: 20, color: primaryColor)
                      : Icon(Icons.camera_alt, size: 20, color: primaryColor),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile?.name ?? "Name not set",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        if (user.email != null)
          Text(
            "@${(user.email ?? "N/A").split("@")[0]}",
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildInfoSection(ProfileViewModel viewModel) {
    final user = viewModel.user!;
    final profile = viewModel.userProfile;

    return Column(
      children: [
        _buildExpandableCard(
          title: "Personal Information",
          children: [
            viewModel.editMode
                ? _editableField("Name", viewModel.nameController)
                : _infoTile("Name", profile?.name ?? "-"),
            _infoTile("Email", user.email ?? "N/A"),
            viewModel.editMode
                ? _editableField("Phone", viewModel.phoneController)
                : _infoTile("Phone", user.phoneNumber ?? "N/A"),
            viewModel.editMode
                ? _editableField("Address", viewModel.addressController)
                : _infoTile("Address", profile?.location ?? "-"),
          ],
        ),
        const SizedBox(height: 16),
        _buildExpandableCard(
          title: "Login and Security",
          children: [
            _infoTile("Role", user.role ?? "N/A"),
            _infoTile("Device ID", user.deviceId ?? "N/A"),
            _infoTile(
              "Is Active",
              (profile?.isActive ?? false) ? "Yes" : "No",
              color: (profile?.isActive ?? false)
                  ? Colors.green
                  : Colors.redAccent,
            ),
          ],
        ),
        if (viewModel.user!.role.toString().toLowerCase() == "donor")
          _buildExpandableCard(title: "Your Pets", children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...viewModel.pet!.map((pet) => _buildPetCard(pet, viewModel)),
              ],
            ),
          ])
      ],
    );
  }

  Widget _buildPetCard(PetResponse pet, ProfileViewModel viewModel) {
    final Color statusColor = viewModel.getColor(pet.isApproved ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rounded Image
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: pet.image != null
                ? Image.network(
                    pet.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/nopet.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),

          // Pet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Link
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pet.name ?? "Unnamed",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await viewModel.gotopetDetail(pet);
                      },
                      child: const Icon(Icons.link, color: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Approval + Live Status Badges
                Row(
                  children: [
                    // isApproved Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pet.isApproved ?? "Pending",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // isLive Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (pet.isLive ?? false)
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (pet.isLive ?? false) ? "Live" : "Inactive",
                        style: TextStyle(
                          color:
                              (pet.isLive ?? false) ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Remaining Info
                _infoLine("Animal", pet.animal),
                _infoLine("Breed", pet.breed),
                _infoLine("Age", pet.age?.toString()),
                _infoLine("Gender", pet.gender),
                _infoLine("Location", pet.location),
                if (pet.description != null)
                  _infoLine("About", pet.description),
                if (pet.rejectionReason != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "Rejected: ${pet.rejectionReason}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: value ?? "N/A",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          splashColor: accentColor.withOpacity(0.1),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16,
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, {Color? color}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color ?? primaryColor,
          )),
    );
  }

  Widget _logoutButton(BuildContext context, ProfileViewModel viewModel) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 99, 34, 10),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: const Text("Logout", style: TextStyle(fontSize: 16)),
      onPressed: () => viewModel.logout(),
    );
  }
}
