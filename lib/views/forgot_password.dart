import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _emailController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthenticationViewModel>();

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 130),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 247, 240),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildForgotPasswordForm(viewModel),
                            const SizedBox(height: 20),
                            _buildResetPasswordButton(viewModel),
                            const SizedBox(height: 10),
                            _buildBackToLogin(viewModel),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: _buildCharacterImage(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterImage() {
    return Image.asset(
      'assets/images/admin.png', // Replace or reuse your image
      height: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildForgotPasswordForm(AuthenticationViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "RESET PASSWORD",
            style: TextStyle(
              color: Colors.brown.shade700,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          DefaultTextInput(
            controller: _emailController,
            hintText: "Email",
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DefaultTextInput(
            controller: _newPasswordController,
            hintText: "New Password",
            icon: Icons.lock_outline,
            isPassword: true,
            secureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DefaultTextInput(
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            icon: Icons.lock_outline,
            isPassword: true,
            secureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm your new password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordButton(AuthenticationViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(255, 148, 40, 7),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: GestureDetector(
        child: const Text(
          "Reset Password",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        onTap: () {
          if (_formKey.currentState!.validate()) {
            viewModel.ForgotPassword(
              _emailController.text,
              _newPasswordController.text,
            );
          }
        },
      ),
    );
  }

  Widget _buildBackToLogin(AuthenticationViewModel viewModel) {
    return TextButton(
      onPressed: () {
        viewModel.gotoLogin();
      },
      child: const Text(
        "Back to Login",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
