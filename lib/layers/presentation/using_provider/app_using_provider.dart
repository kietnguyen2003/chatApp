import 'package:chat_app/layers/data/auth_repository_impl.dart';
import 'package:chat_app/layers/data/conversation_repository_imp.dart';
import 'package:chat_app/layers/data/source/network/api.dart';
import 'package:chat_app/layers/domain/usecase/conversation.dart';
import 'package:chat_app/layers/domain/usecase/login.dart';
import 'package:chat_app/layers/presentation/using_provider/features/auth/change_notifier/auth_change_notifier.dart';
import 'package:chat_app/layers/presentation/using_provider/features/auth/login_page.dart';
import 'package:chat_app/layers/presentation/using_provider/features/chat_page/chang_notifer/chat_change_notifer.dart';
import 'package:chat_app/layers/presentation/using_provider/features/chat_page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/main.dart' as main_app;

class AppUsingProvider extends StatelessWidget {
  const AppUsingProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => AuthChangeNotifier(
                loginUseCase: Login(
                  authRepository: AuthRepositoryImpl(api: ApiImpl()),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ChatChangeNotifer(
                conversationUseCase: Conversation(
                  conversationRepository: ConversationRepositoryImp(
                    api: ApiImpl(),
                  ),
                ),
              ),
        ),
      ],
      child: Consumer2<AuthChangeNotifier, ChatChangeNotifer>(
        builder: (context, auth, chat, _) {
          if (auth.auth != null) {
            return ChatPage(auth.auth!);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
