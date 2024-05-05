import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';

///Abstract class for database
abstract class IDatabaseService {
  ///Default constructor of [IDatabaseService]
  IDatabaseService();

  ///Check if user e-mail is verified using OTP
  Future<bool> isEmailVerified(String userID) async {
    throw UnimplementedError();
  }

  ///Send user email verification status
  Future<void> setEmailVerificationStatus({
    required String userID,
    required bool isVerified,
  }) async {
    throw UnimplementedError();
  }

  ///Save chat to firebase
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
  ///[lastTimeConversationTimestamp] if passed start the query
  ///from that document up to
  ///the [limit]
  Future<List<Conversation>> getLastChats({
    required String userID,
    int? lastTimeConversationTimestamp,
    int limit = 10,
  }) async {
    throw UnimplementedError();
  }
}
