import 'package:flutter/material.dart';
import 'package:petadoption/custom_widgets/default_text_input.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/viewModel/signup_view_model.dart';
import 'package:provider/provider.dart';
import '../viewModel/authentication_view_model.dart';

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
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Stack(
      children: [
        // White login container
        Positioned(
          top: 130, // adjust as needed
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), // top padding gives space for character image
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLoginForm(viewModel),
               
                 buildRoleSelector(roles:roles,selectedRole: viewModel.role,onRoleSelected: (role) {
      
        viewModel.setRole(role);
      
    }),
                _buildLoginButton(viewModel),
                 _buildLogin(viewModel),
                
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
)
,
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
    return Column(
      spacing: 15,
      children: [
        Text("SIGNUP",style: TextStyle(color: const Color.fromARGB(255, 146, 61, 5),fontSize: 30,fontWeight: FontWeight.w700),),
         DefaultTextInput(
          controller: nameController,
          hintText: "Name",
          icon: Icons.person,
        ),
        DefaultTextInput(
          controller: emailController,
          hintText: "Email",
          icon: Icons.email_outlined,
        ),
        DefaultTextInput(
          controller: numberController,
          hintText: "PhoneNumber",
          icon: Icons.phone,
        ),
        DefaultTextInput(
          controller: passwordController,
          hintText: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          showPassword: viewModel.getShowPassword,
          secureText:viewModel.getShowPassword ,
          onEyePressed: ()
          {
            viewModel.setShowPassword(!viewModel.getShowPassword);
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(SignupViewModel viewModel) {
    return Container(
      padding: EdgeInsets.fromLTRB(60,10,60,10),
     decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
       color: Colors.deepOrange,
     ),
      child: GestureDetector(
        child: Text( "Sign Up",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
      onTap: () {
        viewModel.Signup(emailController.text, passwordController.text,numberController.text);
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
            "  Login",style: TextStyle(
              fontWeight: FontWeight.w600,color: Colors.deepOrange
            ),
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

      return GestureDetector(
        onTap: () => onRoleSelected(role),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange.shade100 :Color.fromARGB(255, 255, 247, 240),
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
                height: height*0.10,
                width: width*0.20,
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
