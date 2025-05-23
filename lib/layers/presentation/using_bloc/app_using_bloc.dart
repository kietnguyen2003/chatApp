import 'package:chat_app/layers/data/auth_repository_impl.dart';
import 'package:chat_app/layers/data/conversation_repository_imp.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:chat_app/layers/presentation/using_bloc/features/auth/cubit/auth_cubit_cubit.dart';
import 'package:chat_app/layers/presentation/using_bloc/features/auth/login_bloc_page.dart';
import 'package:chat_app/layers/presentation/using_bloc/features/chat/chat_cubbit_page.dart';
import 'package:chat_app/layers/presentation/using_bloc/features/chat/cubit/chatcubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/main.dart' as main_app;

class AppUsingBloc extends StatelessWidget {
  const AppUsingBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthCubitCubit(
                authRepository: AuthRepositoryImpl(api: ApiImpl()),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChatCubit(
                conversationUseCase: Conversation(
                  conversationRepository: ConversationRepositoryImp(
                    api: ApiImpl(),
                  ),
                ),
              ),
        ),
      ],
      child: BlocConsumer<AuthCubitCubit, AuthCubitState>(
        listener: (context, state) {
          if (state is AuthCubitSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthCubitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          print('AppUsingBloc: Building with state - $state');
          if (state is AuthCubitLoggedIn) {
            return ChatCubitPage(
              state.auth.accessToken ?? "",
              state.auth.refreshToken ?? "",
            );
          } else if (state is AuthCubitInitial) {
            return const LoginBlocPage();
          }
          return const LoginBlocPage();
        },
      ),
    );
  }
}
