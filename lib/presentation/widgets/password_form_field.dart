import 'package:dictionary/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordFormField extends HookWidget {
  const PasswordFormField({
    super.key,
    this.controller,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final obscurePassword = useState(true);

    return CustomTextFormField(
      controller: controller,
      hintText: 'Password',
      enabled: enabled,
      suffix: IconButton(
        onPressed: () {
          obscurePassword.value = !obscurePassword.value;
        },
        icon: Icon(
          obscurePassword.value ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      obscureText: obscurePassword.value,
    );
  }
}
