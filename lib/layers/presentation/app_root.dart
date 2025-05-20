import 'package:chat_app/layers/presentation/using_bloc/app_using_bloc.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late StateManagementOptions _currentOption;

  @override
  void initState() {
    super.initState();
    // sử dụng architecture nào;
    _currentOption = StateManagementOptions.bloc;
    // khởi tạo api;
    // final api = ApiIml();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home:
            // _currentOption == StateManagementOptions.provider
            //     ? const AppUsingProvider()
            //     : const Placeholder(), // Chuyển đổi giữa các ứng dụng dựa trên lựa chọn
            _currentOption == StateManagementOptions.bloc
                ? const AppUsingBloc() // Chuyển đổi giữa các ứng dụng dựa trên lựa chọn
                : const Placeholder(),
      ),
    );
  }
}
