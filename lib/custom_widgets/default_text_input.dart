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
        style: const TextStyle(fontSize: 14, height: 1.3),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: icon != null ? Icon(icon, size: 20) : null,
          suffixIcon: suffixicon
              ? IconButton(
                  onPressed: onEyePressed,
                  icon: Icon(
                    secureText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}
