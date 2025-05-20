import 'package:chat_app/layers/presentation/using_bloc/features/auth/cubit/auth_cubit_cubit.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class LoginBlocPage extends StatefulWidget {
  const LoginBlocPage({super.key});

  @override
  State<LoginBlocPage> createState() => _LoginBlocPageState();
}

class _LoginBlocPageState extends State<LoginBlocPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocBuilder<AuthCubitCubit, AuthCubitState>(
        builder: (context, state) {
          return Column(
            children: [
              Image.asset(
                'assets/lib/hello.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              customTextField(
                controller: usernameController,
                labelText: "Username",
                color: Colors.blue,
                obscureText: false,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  final emailRegex = RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              customTextField(
                controller: passwordController,
                labelText: "Password",
                color: Colors.blue,
                obscureText: true,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                  final username = usernameController.text;
                  final password = passwordController.text;

                  context.read<AuthCubitCubit>().login(username, password);
                  if (state is AuthCubitLoading) {
                    // Show loading indicator
                    toastification.show(
                      context: context,
                      title: const Text('Loading...'),
                      type: ToastificationType.info,
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  } else if (state is AuthCubitError) {
                    toastification.show(
                      context: context,
                      title: Text(state.error),
                      type: ToastificationType.error,
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  } else if (state is AuthCubitSuccess) {
                    // Navigate to chat page
                    toastification.show(
                      context: context,
                      title: Text(state.message),
                      type: ToastificationType.success,
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          );
        },
      ),
    );
  }
}
