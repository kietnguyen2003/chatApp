import 'package:chat_app/layers/domain/entity/bot.dart';

class Botlist {
  static List<Bot> bots = [
    Bot(id: 'claude-3-haiku-20240307', model: 'dify', name: 'CLAUDE_3_HAIKU'),
    Bot(id: 'claude-3-sonnet-20240229', model: 'dify', name: 'CLAUDE_3_SONNET'),
    Bot(id: 'gemini-1.5-flash-latest', model: 'dify', name: 'GEMINI_15_FLASH'),
    Bot(id: 'gemini-1.5-pro-latest', model: 'dify', name: 'GEMINI_15_PRO'),
    Bot(id: 'gpt-4o', model: 'dify', name: 'GPT_4O'),
    Bot(id: 'gpt-4o-mini', model: 'dify', name: 'GPT_4O_MINI'),
  ];
}
