import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:flutter/material.dart';

class ChatCubitPage extends StatefulWidget {
  const ChatCubitPage({super.key});

  @override
  State<ChatCubitPage> createState() => _ChatCubitPageState();
}

class _ChatCubitPageState extends State<ChatCubitPage> {
  List<Message> messages = [
    Message(message: 'Hello', isUser: IsUser.sender, name: "User"),
    Message(
      message: 'Hello, how can I help you?',
      isUser: IsUser.bot,
      name: 'Bot',
    ),
  ];
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(),
          _buildHeader(),
          _builMessageView(messages),
          _BuildChatField(messages, messageController),
        ],
      ),
    );
  }
}

Widget _BuildChatField(
  List<Message> messages,
  TextEditingController controller,
) {
  const String labelText = 'Type your message';
  const Color color = Colors.blue;
  const bool obscureText = false;

  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: customTextField(
            controller: controller,
            labelText: labelText,
            color: color,
            obscureText: obscureText,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              // Simulate sending a message
              Message userMessage = Message(
                message: controller.text,
                isUser: IsUser.sender,
                name: "User",
              );
              Message botMessage = Message(
                message: 'Hello, how can I help you?',
                isUser: IsUser.bot,
                name: 'Bot',
              );
              // Add messages to the list
              messages.add(userMessage);
              messages.add(botMessage);

              // Clear the text field
              controller.clear();
            }
          },
        ),
      ],
    ),
  );
}

Widget _builMessageView(List<Message> messages) {
  return Expanded(
    child: ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildBubble(messages[index]);
      },
    ),
  );
}

Widget _buildBubble(Message message) {
  return Column(
    crossAxisAlignment:
        message.isUser == IsUser.sender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Text(
          message.name,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              message.isUser == IsUser.sender
                  ? Colors.blue[100]
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color:
                message.isUser == IsUser.sender ? Colors.black : Colors.black87,
          ),
        ),
      ),
    ],
  );
}

Widget _buildHeader() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildIconButton("assets/lib/icons/light.png", () {
                  // Handle light icon action
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildIconButton("assets/lib/icons/dart.png", () {
                  // Handle light icon action
                }),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildIconButton("assets/lib/icons/list.png", () {
                  // Handle light icon action
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.settings),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  'assets/lib/hello.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSeletor('Select Bot', 'claude-3-haiku-20240307', (value) {}),
        ],
      ),
      const Divider(),
    ],
  );
}

Widget _buildSeletor(
  String title,
  String selectBotId,
  Function(String) onChanged,
) {
  List<Bot> bots = Botlist.bots;
  Bot currentSelectedBot = bots.firstWhere(
    (element) => element.id == selectBotId,
  );
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        currentSelectedBot.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_drop_down)),
    ],
  );
}

Widget _buildIconButton(String iconPath, VoidCallback onPressed) {
  return IconButton(
    icon: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 20,
      child: Image.asset(iconPath, width: 32, height: 32),
    ),
    onPressed: onPressed,
  );
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    title: const Text(
      'KitChat App',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      IconButton(
        icon: Image.asset('assets/lib/icons/list.png', width: 40, height: 40),
        onPressed: () {
          // Handle settings action
        },
      ),
    ],
    leading: IconButton(
      icon: Image.asset('assets/lib/hello.png', width: 40, height: 40),
      onPressed: () {
        // Handle back action
      },
    ),
  );
}
