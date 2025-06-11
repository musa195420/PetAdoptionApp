import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool suffixicon;
  final Function()? onEyePressed;
  final Function()? onTap;
  final int? maxLines;
  final TextAlign align;
  final TextInputType keyboardType;
  final Color fillColor;

  const DefaultTextInput({
    super.key,
    this.formatters,
    this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.showPassword = false,
    this.align = TextAlign.left,
    this.enabled = true,
    this.isDropDown = false,
    this.onChanged,
    this.onEyePressed,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.icon,
    this.suffixicon = false,
    this.labelText,
    this.visibility = true,
    this.secureText = false,
    this.border = true,
    this.fillColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: TextFormField(
        onTap: onTap,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        obscureText: secureText,
        maxLines: maxLines,
        textAlign: align,
        inputFormatters: formatters,
        readOnly: isDropDown || readOnly,
        enabled: enabled,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: suffixicon
              ? IconButton(
                  onPressed: onEyePressed,
                  icon: Icon(Icons.remove_red_eye),
                )
              : null,
          filled: true,
          fillColor: fillColor,
          border: border ? const OutlineInputBorder() : InputBorder.none,
        ),
      ),
    );
  }
}
