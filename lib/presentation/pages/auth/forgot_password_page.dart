import 'package:dictionary/core/hooks/use_bloc_subscription.dart';
import 'package:dictionary/core/util/snackbar.dart';
import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();

    useBlocSubscription<AuthCubit, AuthState>(context, (state) {
      if (state is ResetPasswordEmailSent) {
        showSnackbar(
          context: context,
          message: 'Email was sent successfully!',
          type: SnackbarType.success,
        );
        context.pop();
      }

      if (state is AuthError) {
        showSnackbar(
          context: context,
          message: state.errorMessage,
          type: SnackbarType.failure,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot your password?'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'To reset your password, please enter the email you registered in the form below.'),
                  const SizedBox(height: 8),
                  const Text(
                      'If you don\'t see the email in your inbox, please check your spam folder.'),
                  const SizedBox(height: 32),
                  const Text('Email:'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: 'Email',
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              BlocProvider.of<AuthCubit>(context)
                                  .sendPasswordResetEmail(emailController.text);
                            },
                      child: const Text('Send'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
