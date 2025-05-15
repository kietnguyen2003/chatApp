class ApiUrls {
  static const String authUrl = 'https://auth-api.dev.jarvis.cx/api/v1/';
  static const String knowledgeBaseUrl = 'https://knowledge-api.dev.jarvis.cx/';
  static const String jarvisUrl = 'https://api.dev.jarvis.cx/api/v1/';

  static const String profile = '${jarvisUrl}auth/me';

  static const String login = '${authUrl}auth/password/sign-in';
  static const String register = '${authUrl}auth/password/sign-up';
  static const String refreshToken = '${authUrl}auth/sessions/current/refresh';

  // AI Chat
  static const String aiChat = '${jarvisUrl}ai-chat/messages';
  static const String aiChatHistory = '${jarvisUrl}ai-chat/conversations';

  static const String conversationOverview =
      '${jarvisUrl}ai-chat/conversations';

  // Token Usage
  static const String tokenUsage = '${jarvisUrl}tokens/usage';

  // AI Email
  static const String aiEmail = '${jarvisUrl}ai-email/reply-ideas';
  static const String aiEmailReply = '${jarvisUrl}ai-email';

  // Bot Agent
  static const String botAgent = '${knowledgeBaseUrl}kb-core/v1/ai-assistant';

  // Knowledge Base
  static const String knowledgeBase = '${knowledgeBaseUrl}kb-core/v1/knowledge';
  static const String knowledgeIntegrationTelegram =
      '${knowledgeBaseUrl}kb-core/v1/bot-integration/telegram/publish';
  static const String knowledgeIntegrationSlack =
      '${knowledgeBaseUrl}kb-core/v1/bot-integration/slack/publish';

  // Subscription
  static const String subscription = '${jarvisUrl}subscriptions/subscribe';
  static const String mySubscription = '${jarvisUrl}subscriptions/me';

  static const String botAgentDelete =
      '${knowledgeBaseUrl}kb-core/v1/ai-assistant';
}
