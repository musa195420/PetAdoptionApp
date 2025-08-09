import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/viewModel/admin_view_models/user_admin_view_model.dart';
import 'package:provider/provider.dart';

class UserEditModal extends StatefulWidget {
  final User user;
  const UserEditModal({super.key, required this.user});

  @override
  State<UserEditModal> createState() => _UserEditModalState();
}

class _UserEditModalState extends State<UserEditModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController emailController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<UserAdminViewModel>();

    emailController = TextEditingController(text: widget.user.email);
    numberController = TextEditingController(text: widget.user.phoneNumber);

    viewModel.role = widget.user.role ?? "N/A";
  }

  @override
  void dispose() {
    emailController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserAdminViewModel>();

    return Scaffold(
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
                    _buildCharacterImage(viewModel),
                    Container(
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
                          _buildUpdateUser(viewModel),
                          const SizedBox(height: 10),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                viewModel.updateUser(emailController.text,
                                    numberController.text, widget.user);
                              }
                            },
                            child: _buildUpdateUserButton(),
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

  Widget _buildUpdateUser(UserAdminViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 5,
        children: [
          const SizedBox(height: 15),
          DefaultTextInput(
            controller: emailController,
            hintText: "Email",
            icon: Icons.email_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Email Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: numberController,
            hintText: "Phone Number",
            icon: Icons.mobile_friendly,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Number Please';
              }
              return null;
            },
          ),
          buildRoleSelector(
            roles: viewModel.roles,
            selectedRole: viewModel.role,
            onRoleSelected: (role) {
              viewModel.setRole(role);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage(UserAdminViewModel viewModel) {
    final user = widget.user;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 255, 247, 240),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: viewModel.path != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(viewModel.path!),
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                )
              : user.profileImage != null && user.profileImage!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: user.profileImage!,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          height: 130,
                          width: 130,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/noprofile.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/noprofile.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    viewModel.path != null ? Colors.brown : Colors.deepOrange,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () async {
                  await viewModel.savePetImagePath();
                },
                child: Text(
                  viewModel.path != null || user.profileImage != null
                      ? "Change Image"
                      : "Add Image",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (viewModel.path != null)
              GestureDetector(
                onTap: () {
                  viewModel.removeImagePath();
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.deepOrange,
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget buildRoleSelector({
    required List<String> roles,
    required String selectedRole,
    required Function(String) onRoleSelected,
  }) {
    final imagePaths = {
      'Donor': 'assets/images/donor.png',
      'Adopter': 'assets/images/adopter.png',
      'Admin': 'assets/images/admin.png',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: roles.map((role) {
        final isSelected = role == selectedRole;

        return InkWell(
          onTap: () => onRoleSelected(role),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.orange.shade100
                  : const Color.fromARGB(255, 255, 247, 240),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePaths[role] ?? '',
                  height: 80,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.orange.shade900 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpdateUserButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: const Text(
        "Update User",
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
