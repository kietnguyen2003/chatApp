import 'package:chat_app/layers/data/auth_repository_impl.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/usecase/login.dart';
import 'package:chat_app/layers/presentation/using_provider/auth/change_notifier/auth_change_notifier.dart';
import 'package:chat_app/layers/presentation/using_provider/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/main.dart' as main_app;

class AppUsingProvider extends StatelessWidget {
  const AppUsingProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => AuthChangeNotifier(
            loginUseCase: Login(
              authRepository: AuthRepositoryImpl(api: ApiImpl()),
            ),
            sharedPreferences: main_app.sharedPref,
          ),
      child: const LoginPage(),
    );
  }
}
