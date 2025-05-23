import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/domain/entity/auth.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/conversation.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/presentation/using_provider/features/chat_page/chang_notifer/chat_change_notifer.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:chat_app/layers/presentation/widget/selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Auth auth;
  const ChatPage(this.auth, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final TextEditingController controller = TextEditingController();
  String title = 'Select Bot';
  String selectBotId = 'claude-3-haiku-20240307';

  // Function to transform bolded text (**text**) to uppercase
  String formatResponse(String response) {
    return response.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (Match match) => match.group(1)!.toUpperCase(),
    );
  }

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
              return [
                const PopupMenuItem(value: 1, child: Text('Logout')),
                const PopupMenuItem(value: 2, child: Text('History')),
              ];
            },
            onSelected: (value) async {
              if (value == 1) {
                chatChangeNotifier.logout();
                // Navigation handled in AppUsing tirProvider
              } else if (value == 2) {
                await chatChangeNotifier.getHistoryConversations(selectBotId);
                showDialog(
                  context: context,
                  builder: (context) {
                    return buildHistoryDialog(
                      context,
                      chatChangeNotifier.historyConversations,
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildConversation(chatChangeNotifier)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildSelector(
                  title: title,
                  selectBotId: selectBotId,
                  onChanged: (selected) {
                    setState(() {
                      selectBotId = selected;
                      title =
                          Botlist.bots
                              .firstWhere((element) => element.id == selected)
                              .name;
                    });
                  },
                ),
                const Divider(),
                Row(
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
                      onPressed:
                          chatChangeNotifier.isLoading
                              ? null
                              : () {
                                if (controller.text.isNotEmpty) {
                                  Bot bot = Botlist.bots.firstWhere(
                                    (element) => element.id == selectBotId,
                                  );

                                  chatChangeNotifier.sendMessage(
                                    controller.text,
                                    bot,
                                    widget.auth.accessToken ?? '',
                                  );
                                  controller.clear();
                                }
                              },
                      icon:
                          chatChangeNotifier.isLoading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryDialog(
    BuildContext context,
    HistoryConversations historyItems,
  ) {
    return AlertDialog(
      title: const Text('History'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: historyItems.items.length,
          itemBuilder: (context, index) {
            final item = historyItems.items[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                DateTime.tryParse(item.createdAt) != null
                    ? "${DateTime.parse(item.createdAt).day.toString().padLeft(2, '0')}/"
                        "${DateTime.parse(item.createdAt).month.toString().padLeft(2, '0')}/"
                        "${DateTime.parse(item.createdAt).year} "
                        "${DateTime.parse(item.createdAt).hour.toString().padLeft(2, '0')}:"
                        "${DateTime.parse(item.createdAt).minute.toString().padLeft(2, '0')}"
                    : item.createdAt,
              ),
              onTap: () {
                // Handle history item tap
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget buildConversation(ChatChangeNotifer chatChangeNotifier) {
    return ListView.builder(
      itemCount: chatChangeNotifier.messages.length,
      itemBuilder: (context, index) {
        final message = chatChangeNotifier.messages[index];
        // Format the message to convert bolded text to uppercase
        final formattedMessage = formatResponse(message.message);
        return Align(
          alignment:
              message.isUser == IsUser.sender
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment:
                  message.isUser == IsUser.sender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Icon(
                  message.isUser == IsUser.sender
                      ? Icons.person
                      : Icons.android,
                  color:
                      message.isUser == IsUser.sender
                          ? Colors.blue
                          : Colors.green,
                ),
                Text(
                  message.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        message.isUser == IsUser.sender
                            ? Colors.blue
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    formattedMessage,
                    style: TextStyle(
                      color:
                          message.isUser == IsUser.sender
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
