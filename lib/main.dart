import 'package:chat_app/layers/presentation/app_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StateManagementOptions { bloc, cubit, provider, riverpod, getIt, mobX }

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  Animate.restartOnHotReload = true;
  runApp(const AppRoot());
}
