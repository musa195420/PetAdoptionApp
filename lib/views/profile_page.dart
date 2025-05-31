import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:petadoption/viewModel/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

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
                    children: [
                      const SizedBox(height: 20),
                      _profileHeader(viewModel),
                      const SizedBox(height: 20),
                      _buildInfoSection(viewModel),
                      const SizedBox(height: 24),
                      _logoutButton(context, viewModel),
                    ],
                  ),
                ),
              ),
      ),
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
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : const AssetImage('assets/images/noprofile.png')
                      as ImageProvider,
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(Icons.camera_alt, size: 20, color: primaryColor),
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
        if (user.email.isNotEmpty)
          Text(
            "@${user.email.split("@")[0]}",
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
            _infoTile("Email", user.email),
            viewModel.editMode
                ? _editableField("Phone", viewModel.phoneController)
                : _infoTile("Phone", user.phoneNumber ?? "-"),
            viewModel.editMode
                ? _editableField("Address", viewModel.addressController)
                : _infoTile("Address", profile?.location ?? "-"),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      viewModel.seteditMode(!viewModel.editMode);
                    },
                    child: Icon(
                      Icons.edit,
                      size: 25,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildExpandableCard(
          title: "Login and Security",
          children: [
            _infoTile("Role", user.role),
            _infoTile("Device ID", user.deviceId),
            _infoTile(
              "Is Active",
              (profile?.isActive ?? false) ? "Yes" : "No",
              color: (profile?.isActive ?? false)
                  ? Colors.green
                  : Colors.redAccent,
            ),
          ],
        ),
      ],
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
        backgroundColor: Color.fromARGB(255, 213, 101, 25),
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
