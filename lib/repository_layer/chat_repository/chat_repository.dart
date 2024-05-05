import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/data_layer/static/api_constants.dart';
import 'package:chatgpt/repository_layer/chat_repository/chat_repository_interface.dart';
import 'package:chatgpt/service_layer/database_service/database_service_interface.dart';
import 'package:chatgpt/service_layer/service_locator.dart';

///Implementation of [IChatRepository] for chat completion
class ChatRepository implements IChatRepository {
  ///Default constructor for [ChatRepository]
  ChatRepository(this.databaseService);

  ///Instance for Implementation of [IDatabaseService] to save and
  /// fetch chat data
  final IDatabaseService databaseService;

  @override
  Future<ChatMessage> getNextMessageInChat({
    required List<ChatMessage> messages,
  }) async {
    const errorMessage = ChatMessage(
      role: ChatMessageRole.assistant,
      content: "Couldn't get response from bot. Try again!",
      isError: true,
    );
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${appConfig.openAIAPIKey}',
      };

      final messagesJSON = <Map<String, dynamic>>[];

      for (final message in messages) {
        if (!message.isError) {
          messagesJSON.add(message.toAPIJson());
        }
      }

      final result = await apiService.postRequest(
        APIConstants.chatCompletion,
        {
          'model': 'gpt-3.5-turbo-0125',
          'messages': messagesJSON,
        },
        headers: headers,
      );

      if (result.exception == null &&
          result.data != null &&
          result.data!['choices']! is List &&
          (result.data!['choices']! as List).isNotEmpty &&
          (result.data!['choices']! as List).first is Map<String, dynamic> &&
          ((result.data!['choices']! as List).first
              as Map<String, dynamic>)['message'] is Map<String, dynamic>) {
        return ChatMessage.fromJson(
          ((result.data!['choices']! as List).first
              as Map<String, dynamic>)['message'] as Map<String, dynamic>,
        );
      } else if ([403, 429, 500, 503].contains(result.statusCode)) {
        var error = 'Country, region, or territory not supported';
        if (result.statusCode == 429) {
          error = 'Limit or quota exceeded';
        } else if (result.statusCode == 500) {
          error = 'The server had an error while processing your request';
        } else if (result.statusCode == 503) {
          error = 'The engine is currently overloaded, please try again later';
        }
        return errorMessage.copyWith(content: error);
      } else {
        return errorMessage;
      }
    } catch (e) {
      apiService.log.d(e);
      return errorMessage;
    }
  }

  @override
  Future<void> saveChat({
    required String userID,
    required String chatID,
    required String chatName,
    required List<ChatMessage> messages,
    bool merge = true,
  }) async {
    return databaseService.saveChat(
      userID: userID,
      chatID: chatID,
      chatName: chatName,
      messages: messages,
      merge: merge,
    );
  }

  @override
  Future<List<Conversation>> getLastChats({
    required String userID,
    int? lastTimeConversationTimestamp,
    int limit = 10,
  }) async {
    return databaseService.getLastChats(
      userID: userID,
      lastTimeConversationTimestamp: lastTimeConversationTimestamp,
      limit: limit,
    );
  }
}
