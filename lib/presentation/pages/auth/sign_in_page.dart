import 'package:dictionary/presentation/pages/auth/cubit/auth_cubit.dart';
import 'package:dictionary/presentation/widgets/custom_text_form_field.dart';
import 'package:dictionary/presentation/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends HookWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                final errorMessage =
                    state is StateError ? (state as StateError).message : '';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      hintText: 'Email',
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 16),
                    PasswordFormField(
                      controller: passwordController,
                      enabled: !isLoading,
                    ),
                    errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              errorMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final email = emailController.text;
                              final password = passwordController.text;

                              BlocProvider.of<AuthCubit>(context)
                                  .signIn(email: email, password: password);
                            },
                      child: const Text('Sign in'),
                    ),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go('/create_account');
                            },
                      child: const Text('Create account'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go('/forgot_password');
                            },
                      child: const Text('Forgot your password?'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
