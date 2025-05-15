import 'package:chat_app/layers/presentation/using_provider/auth/change_notifier/auth_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authChangeNotifier = Provider.of<AuthChangeNotifier>(
      context,
      listen: true,
    );
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    // Kiểm tra trạng thái error hoặc auth để hiển thị toast
    if (authChangeNotifier.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toastification.show(
          context: context,
          title: Text(authChangeNotifier.error!),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 5),
        );
      });
    } else if (authChangeNotifier.auth != null &&
        !authChangeNotifier.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toastification.show(
          context: context,
          title: const Text('Login successful'),
          type: ToastificationType.success,
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
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
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
                      title: const Text('Please enter username and password'),
                      type: ToastificationType.warning,
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            if (authChangeNotifier.auth != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Logged in! Token: ${authChangeNotifier.auth!.accessToken}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
