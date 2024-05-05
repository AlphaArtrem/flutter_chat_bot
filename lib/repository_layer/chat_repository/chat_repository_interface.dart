import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';

///Abstract class for chat
abstract class IChatRepository {
  ///Default constructor of [IChatRepository]
  IChatRepository();

  ///Get next response in chat from bot using chat completion API
  Future<ChatMessage> getNextMessageInChat({
    required List<ChatMessage> messages,
  }) async {
    throw UnimplementedError();
  }

  ///Save chat to database
  Future<void> saveChat({
    required String userID,
    required String chatID,
    required String chatName,
    required List<ChatMessage> messages,
    bool merge = true,
  }) async {
    throw UnimplementedError();
  }

  ///Get chats for [limit] from the database order by timestamp
  ///[lastTimeConversationTimestamp] if passed start the
  ///query from that document up to
  ///the [limit
  Future<List<Conversation>> getLastChats({
    required String userID,
    int? lastTimeConversationTimestamp,
    int limit = 10,
  }) async {
    throw UnimplementedError();
  }
}
