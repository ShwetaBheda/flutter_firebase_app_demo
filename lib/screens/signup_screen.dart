import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/auth_event.dart';
import 'package:flutter_task/blocs/auth_state.dart';
import 'package:flutter_task/common_widgets/custom_text_field.dart';
import '../blocs/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor:
                        Colors.redAccent, // Consistent error styling
                  ),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom TextFormField for Username
                CustomTextFormField(
                  controller: usernameController,
                  label: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Custom TextFormField for Email
                CustomTextFormField(
                  controller: emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    const String emailPattern =
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    final RegExp regex = RegExp(emailPattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Custom TextFormField for Password
                CustomTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Remove focus from any text fields
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SignUpRequested(
                                email: emailController.text,
                                password: passwordController.text,
                                username: usernameController.text,
                              ));
                        }
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
