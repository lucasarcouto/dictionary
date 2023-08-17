import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: suffix,
      ),
      obscureText: obscureText,
    );
  }
}
