enum IsUser { sender, bot }

class Message {
  String message;
  IsUser isUser;
  String name;

  Message({required this.message, required this.isUser, required this.name});
}
