import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_visibility_builder.dart';
class LoginTextInput extends StatelessWidget {
  final List<TextInputFormatter>? formatters;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool showPassword;
  final  IconData? icon;
  final bool readOnly;
  final bool enabled;
  final Function()? onEyePressed;
  final TextInputType keyboardType;
  final Function()? onTap;
  const LoginTextInput(
      {super.key, this.onTap, this.readOnly=false, this.enabled=true, this.formatters, this.keyboardType=TextInputType.text, this.hintText, this.controller, this.validator, this.isPassword=false, this.showPassword=false, this.onEyePressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (BuildContext context, Widget child) {
      return child;
      },
        child: TextFormField( onTap: onTap, enabled: enabled, readOnly: readOnly, keyboardType: keyboardType, onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
                  autocorrect: false,
                  obscureText: isPassword? !showPassword: false,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    suffixIcon: isPassword? IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined, color: Colors.grey, size: 25,
                        ),
                        onPressed: onEyePressed,
                      ):const SizedBox(),
                    border: const OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: const OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(5))),
                      prefixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Icon(icon, size: 25, color: Colors.grey,)),
                          fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(12),
                      hintText: hintText,
                      labelStyle: const TextStyle(fontSize: 18),
                       hintStyle: const TextStyle(fontSize: 18,color: Colors.grey,),),
                  key: GlobalKey<FormFieldState>(),
                  controller: controller,
                  // The validator receives the text that the user has entered.
                  validator: validator,
                )
    );
  }
}
