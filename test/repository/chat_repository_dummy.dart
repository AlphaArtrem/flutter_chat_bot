import 'dart:math';

import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/repository_layer/chat_repository/chat_repository_interface.dart';

class ChatRepositoryDummy implements IChatRepository {
  ChatRepositoryDummy(this.json);
  final Map<String, dynamic> json;

  @override
  Future<List<Conversation>> getLastChats({
    required String userID,
    int? lastTimeConversationTimestamp,
    int limit = 1,
  }) async {
    final list = <Conversation>[];
    final chats = json['chats'] as List;
    for (var i = 0; i < min(limit, chats.length); i++) {
      list.add(
        Conversation.fromJson(
          json: (json['chats'] as List)[i] as Map<String, dynamic>,
          id: DateTime.timestamp().toString(),
        ),
      );
    }
    return list;
  }

  @override
  Future<ChatMessage> getNextMessageInChat({
    required List<ChatMessage> messages,
  }) async {
    return ChatMessage.fromJson(
      (((json['botResponse'] as Map<String, dynamic>)['choices'] as List)[0]
          as Map<String, dynamic>)['message'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveChat({
    required String userID,
    required String chatID,
    required String chatName,
    required List<ChatMessage> messages,
    bool merge = true,
  }) async {
    (json['chats'] as List).insert(
      0,
      {
        'messages': messages.map((e) => e.toAPIJson()).toList(),
        'lastActive': DateTime.timestamp().millisecondsSinceEpoch,
        'chatName': chatName,
      },
    );
  }
}
