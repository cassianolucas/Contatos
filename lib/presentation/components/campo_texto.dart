import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? initialValue;
  final TextInputType? keyboardType;

  const CampoTexto({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.onChanged,
    this.initialValue,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusColor: Colors.orange,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Icon(suffixIcon),
      ),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      initialValue: initialValue,
      keyboardType: keyboardType,
    );
  }
}
