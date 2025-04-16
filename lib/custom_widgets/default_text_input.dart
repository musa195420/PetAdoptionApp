import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petadoption/custom_widgets/keyboard_visibility_builder.dart';

class DefaultTextInput extends StatelessWidget {
  final List<TextInputFormatter>? formatters;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool isPassword;
  final bool enabled;
  final bool isDropDown;
  final bool showPassword;
  final bool visibility;
  final bool readOnly;
  final bool secureText;
  final bool border;
  final IconData? icon;
   final String? suffixicon;
  final Function()? onEyePressed;
  final Function()? onTap;
  final int? maxLines;
  final TextAlign align; final TextInputType keyboardType; final Color fillColor;
  const DefaultTextInput(
      {super.key,
      this.formatters,
      this.hintText,
      this.controller,
      this.validator,
      this.isPassword = false,
      this.showPassword = false, this.align=TextAlign.left,
      this.enabled = true,
      this.isDropDown = false,
      this.onChanged,
      this.onEyePressed, this.keyboardType=TextInputType.text,
      this.onTap, this.readOnly=false, this.maxLines=1,
      this.icon,this.suffixicon, this.labelText,this.visibility=true,this.secureText=false, this.border=true, this.fillColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visibility,
        child: KeyboardVisibilityBuilder(
          builder: (BuildContext context, Widget child) {
      return child;
      },
          child: TextFormField( onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
            obscureText: secureText,
            maxLines: maxLines, textAlign: align,
            inputFormatters: formatters,
            readOnly: (isDropDown || readOnly)? true:false,
            enabled: enabled,
            autocorrect: false,
            style:  TextStyle(color: enabled ? Colors.black : const Color(0xFF495254)),
            decoration: InputDecoration(
              border: border ? const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))) : InputBorder.none,
              enabledBorder: border ? const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5))) : InputBorder.none,
              fillColor: fillColor,
              filled: true,
              contentPadding: const EdgeInsets.all(12),
              prefixIcon: icon!=null? Icon(color: enabled?Colors.black:Colors.grey,icon, size: 25):null,
              suffixIcon:suffixicon != null ? 
              Icon(color: enabled?Colors.black:Colors.grey,icon, size: 25):
              isDropDown? const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 25,
                  )):isPassword? IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            showPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined, color: Colors.grey, size: 25,
                          ),
                          onPressed: onEyePressed,
                        ):null,
              hintText: hintText,
              labelText: labelText,
              labelStyle: const TextStyle(fontSize: 14, fontWeight:FontWeight.bold),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: const TextStyle(
                  fontSize: 17, color: Colors.grey, fontWeight: FontWeight.normal),
            ),
            key: GlobalKey<FormFieldState>(),
            controller: controller,
            // The validator receives the text that the user has entered.
            validator: validator,
            onTap: onTap,
            onChanged: onChanged,
          ),
        ),
      );
  }
}
