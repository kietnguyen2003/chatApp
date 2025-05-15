import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/presentation/using_provider/chat_page/chang_notifer/chat_change_notifer.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatChangeNotifier = Provider.of<ChatChangeNotifer>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [const PopupMenuItem(value: 1, child: Text('Logout'))];
            },
            onSelected: (value) {
              if (value == 1) {
                chatChangeNotifier.logout();
                // Điều hướng được xử lý ở AppUsing tirProvider
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildConversation()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: customTextField(
                    controller: controller,
                    labelText: "Type your message",
                    color: Colors.blue,
                    obscureText: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        messages.add(
                          Message(
                            message: controller.text,
                            name: 'User',
                            isUser: IsUser.sender,
                          ),
                        );
                        controller.clear();
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConversation() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          title: Text(message.message),
          subtitle: Text(message.name),
          trailing:
              message.isUser == IsUser.sender
                  ? const Icon(Icons.person)
                  : const Icon(Icons.android),
        );
      },
    );
  }
}
