import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
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
                            _buildLoginForm(viewModel),
                            const SizedBox(height: 6),
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
      key: _formKey,
      child: Column(
        children: [
          Text(
            "LOGIN",
            style: TextStyle(
              color: Colors.brown.shade700,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          DefaultTextInput(
            controller: _emailController,
            hintText: "Email",
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DefaultTextInput(
            controller: _passwordController,
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
                return 'Enter your password';
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
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(255, 148, 40, 7),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: GestureDetector(
        child: const Text(
          "Log in",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        onTap: () {
          if (_formKey.currentState!.validate()) {
            viewModel.Login(
              _emailController.text,
              _passwordController.text,
            );
          }
        },
      ),
    );
  }

  Widget _buildForgotPasswordText() {
    return TextButton(
      onPressed: () {
        // implement forgot password logic
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 13,
        ),
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
            "Don't have an account?",
            style: TextStyle(
              color: Colors.black45,
              fontSize: 13,
            ),
          ),
          Text(
            "  Signup",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 194, 55, 13),
              fontSize: 13.5,
            ),
          )
        ],
      ),
    );
  }
}
