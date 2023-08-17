import 'package:dictionary/core/hooks/use_bloc_subscription.dart';
import 'package:dictionary/core/util/dialog.dart';
import 'package:dictionary/core/util/snackbar.dart';
import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/widgets/custom_text_form_field.dart';
import 'package:dictionary/presentation/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class CreateAccountPage extends HookWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    useBlocSubscription<AuthCubit, AuthState>(context, (state) {
      if (state is AccountCreated) {
        showAlertDialog(
          context: context,
          title: 'Success',
          message:
              'Your account was created successfully!\n\nYou will now be redirected to the home page.',
          onButtonPressed: () {
            context.pop();
          },
        );
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
        title: const Text('Create account'),
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
                      'To create a new account, please fill the form below:'),
                  const SizedBox(height: 32),
                  const Text('Email:'),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: 'Email',
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  const Text('Password:'),
                  const SizedBox(height: 8),
                  PasswordFormField(
                    controller: passwordController,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              BlocProvider.of<AuthCubit>(context).createAccount(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            },
                      child: const Text('Create'),
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
