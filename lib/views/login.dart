// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final formKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel viewModel =
        context.watch<AuthenticationViewModel>();

    return StatefulWrapper(
      onInit: () {},
      onDispose: () {},
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
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
                        // Login form container
                        Container(
                          margin: const EdgeInsets.only(top: 130),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 247, 240),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLoginForm(viewModel),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildForgotPasswordText(),
                                ],
                              ),
                              _buildLoginButton(viewModel),
                              _buildSignup(viewModel),
                            ],
                          ),
                        ),

                        // Character image stacked above box
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
      ),
    );
  }

  Widget _buildCharacterImage() {
    return Image.asset(
      'assets/images/login.png',
      height: 150,
      fit: BoxFit.contain,
    );
  }

  Widget _buildLoginForm(AuthenticationViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            "LOGIN",
            style: TextStyle(
              color: const Color.fromARGB(255, 146, 61, 5),
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          DefaultTextInput(
            controller: passwordController,
            hintText: "Password",
            icon: Icons.lock_outline,
            isPassword: true,
            showPassword: viewModel.showPassword,
            secureText: viewModel.showPassword,
            suffixicon: true,
            onEyePressed: () {
              viewModel.setShowPassword();
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

  Widget _buildLoginButton(AuthenticationViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: GestureDetector(
        child: const Text(
          "Log in",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        onTap: () {
          if (formKey.currentState!.validate()) {
            viewModel.Login(emailController.text, passwordController.text);
          }
        },
      ),
    );
  }

  Widget _buildForgotPasswordText() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _buildSignup(AuthenticationViewModel viewModel) {
    return TextButton(
      onPressed: () {
        viewModel.gotoSignup();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Don't Have An Account ?",
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            "  Signup",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
    );
  }
}
