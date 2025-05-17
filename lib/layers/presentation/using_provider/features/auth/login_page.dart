import 'package:chat_app/layers/presentation/using_provider/features/auth/change_notifier/auth_change_notifier.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthChangeNotifier>(
      builder: (context, authChangeNotifier, _) {
        // Hiển thị toast khi có lỗi
        if (authChangeNotifier.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              title: Text(authChangeNotifier.error!),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 5),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('assets/lib/hello.png'),
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                customTextField(
                  controller: usernameController,
                  labelText: 'Email',
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
                  labelText: 'Password',
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
                if (authChangeNotifier.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();
                      if (username.isNotEmpty && password.isNotEmpty) {
                        authChangeNotifier.login(username, password);
                      } else {
                        toastification.show(
                          context: context,
                          title: const Text(
                            'Please enter username and password',
                          ),
                          type: ToastificationType.warning,
                          autoCloseDuration: const Duration(seconds: 5),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
