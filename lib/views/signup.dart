import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/viewModel/signup_view_model.dart';
import 'package:provider/provider.dart';

dynamic formKey = GlobalKey<FormState>();

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  List<String> roles = ["Adopter", "Donor", "Admin"];

  @override
  Widget build(BuildContext context) {
    SignupViewModel viewModel = context.watch<SignupViewModel>();

    return Scaffold(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Character image at top
                    _buildCharacterImage(),

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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          _buildLoginForm(viewModel),
                          const SizedBox(height: 10),
                          Text(
                            "What You Are Select The Role?",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          const SizedBox(height: 5),
                          buildRoleSelector(
                            roles: roles,
                            selectedRole: viewModel.role,
                            onRoleSelected: (role) {
                              viewModel.setRole(role);
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildLoginButton(viewModel),
                          _buildLogin(viewModel),
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

  Widget _buildCharacterImage() {
    return Image.asset(
      'assets/images/signup.png',
      height: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildLoginForm(SignupViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          Text(
            "SIGNUP",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 30,
                fontWeight: FontWeight.w700),
          ),
          DefaultTextInput(
            controller: nameController,
            hintText: "Name",
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Name Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: emailController,
            hintText: "Email",
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Email Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: numberController,
            hintText: "PhoneNumber",
            icon: Icons.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Phone Number Please';
              }
              return null;
            },
          ),
          DefaultTextInput(
            controller: passwordController,
            hintText: "Password",
            icon: Icons.lock_outline,
            isPassword: true,
            showPassword: viewModel.getShowPassword,
            secureText: viewModel.getShowPassword,
            onEyePressed: () {
              viewModel.setShowPassword(!viewModel.getShowPassword);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter Your Password Please';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(SignupViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: GestureDetector(
        child: Text(
          "Sign Up",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () {
          if (formKey.currentState!.validate()) {
            viewModel.Signup(emailController.text, passwordController.text,
                numberController.text, nameController.text);
          }
        },
      ),
    );
  }

  Widget _buildLogin(SignupViewModel viewModel) {
    return TextButton(
      onPressed: () {
        viewModel.gotoLogin();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Already Have An Account ?",
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            "  Login",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.deepOrange),
          )
        ],
      ),
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
                  : Color.fromARGB(255, 255, 247, 240),
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
                  height: height * 0.10,
                  width: width * 0.20,
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
}
