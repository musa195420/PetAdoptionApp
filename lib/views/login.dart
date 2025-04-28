import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/custom_widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';



  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
dynamic formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    AuthenticationViewModel viewModel =
        context.watch<AuthenticationViewModel>();

    return StatefulWrapper(
      onInit: (){},
      onDispose: (){
     
      },
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
            // Login form content with SafeArea
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    // White login container
                    Positioned(
                      top: 170, // adjust as needed
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 247, 240),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20,
                            20), // top padding gives space for character image
                        child: Column(
                          spacing: 10,
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
                    ),
      
                    // Character image on top
                    Align(
                      alignment: Alignment.topCenter,
                      child: _buildCharacterImage(),
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
      height: 200,
      fit: BoxFit.contain,
    );
  }

  Widget _buildLoginForm(AuthenticationViewModel viewModel) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          Text(
            "LOGIN",
            style: TextStyle(
                color: const Color.fromARGB(255, 146, 61, 5),
                fontSize: 40,
                fontWeight: FontWeight.w700),
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
                return 'Enter Your Phone Number Please';
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
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.deepOrange,
      ),
      child: GestureDetector(
        child: Text(
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
      onPressed: () {
        // TODO: Add forgot password logic
      },
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Dont Have An Account ?",
            style: TextStyle(color: Colors.black54),
          ),
          Text(
            "  Signup",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.deepOrange),
          )
        ],
      ),
    );
  }
}
