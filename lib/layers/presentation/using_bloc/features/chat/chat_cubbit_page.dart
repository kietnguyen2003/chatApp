import 'package:chat_app/layers/data/source/local/botList.dart';
import 'package:chat_app/layers/domain/entity/bot.dart';
import 'package:chat_app/layers/domain/entity/messeage.dart';
import 'package:chat_app/layers/presentation/using_bloc/features/chat/cubit/chatcubit_cubit.dart';
import 'package:chat_app/layers/presentation/widget/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubitPage extends StatefulWidget {
  const ChatCubitPage({super.key});

  @override
  State<ChatCubitPage> createState() => _ChatCubitPageState();
}

class _ChatCubitPageState extends State<ChatCubitPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingDialogShown = false;
  List<Message> _currentMessages = [];
  String _selectedBotId = 'claude-3-haiku-20240307';

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: BlocConsumer<ChatcubitCubit, ChatcubitState>(
              listener: (context, state) {
                if (state is ChatcubitLoading && !_isLoadingDialogShown) {
                  _isLoadingDialogShown = true;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => const AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading...'),
                            ],
                          ),
                        ),
                  );
                } else if (state is! ChatcubitLoading &&
                    _isLoadingDialogShown) {
                  Navigator.of(context).pop();
                  _isLoadingDialogShown = false;
                }
                if (state is ChatcubitError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                if (state is ChatcubitMessage) {
                  _currentMessages = state.message;
                }
                if (state is ChatcubitBotChanged) {
                  setState(() {
                    _selectedBotId = state.botId;
                  });
                }
              },
              builder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });
                return _builMessageView(_currentMessages, _scrollController);
              },
            ),
          ),
          _BuildChatField(messageController, context),
        ],
      ),
    );
  }

  Widget _BuildChatField(
    TextEditingController controller,
    BuildContext context,
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
                context.read<ChatcubitCubit>().sendMessage(controller.text);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _builMessageView(List<Message> messages, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _buildBubble(messages[index]);
      },
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
                  message.isUser == IsUser.sender
                      ? Colors.black
                      : Colors.black87,
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
                    // Handle dart icon action
                  }),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildIconButton("assets/lib/icons/list.png", () {
                    // Handle list icon action
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: const Icon(Icons.settings),
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
            BlocBuilder<ChatcubitCubit, ChatcubitState>(
              builder: (context, state) {
                String botId = _selectedBotId;
                if (state is ChatcubitBotChanged) {
                  botId = state.botId;
                }
                return _buildSeletor('Select Bot', botId, (value) {
                  context.read<ChatcubitCubit>().changeBot(value);
                });
              },
            ),
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
      orElse: () => bots.first,
    );

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Select a Bot',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bots.length,
                      itemBuilder: (context, index) {
                        final bot = bots[index];
                        return ListTile(
                          title: Text(bot.name),
                          subtitle: Text(bot.id),
                          selected: bot.id == selectBotId,
                          selectedTileColor: Colors.blue[50],
                          onTap: () {
                            onChanged(bot.id);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Row(
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
          const Icon(Icons.arrow_drop_down),
        ],
      ),
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
}
