import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/service_layer/database_service/database_service_interface.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///Implementation of [IDatabaseService] to fetch data from firebase firestore
///database
class DatabaseService implements IDatabaseService {
  ///Default constructor for [DatabaseService]
  DatabaseService();

  ///Instance of [FirebaseFirestore] to data for user
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ///Getter for [_fireStore]
  static FirebaseFirestore get fireStore => _fireStore;

  ///User collection name
  static const String userVerificationCollection = 'userVerification';

  ///User verification status key
  static const String userVerificationStatus = 'userVerificationStatus';

  ///Chat collection name
  static const String chatCollection = 'chat';

  ///Chat last active timestamp key
  static const String lastActiveField = 'lastActive';

  ///Chat name key
  static const String chatNameField = 'chatName';

  ///Chat messages array key
  static const String messagesField = 'messages';

  @override
  Future<bool> isEmailVerified(String userID) async {
    try {
      final document = await _fireStore
          .collection(userVerificationCollection)
          .doc(userID)
          .get();
      if (document.exists) {
        final data = document.data();
        if (data != null) {
          return data[userVerificationStatus] is bool &&
              data[userVerificationStatus] as bool;
        }
      }
      return false;
    } catch (e) {
      apiService.log.d(e);
      throw Exception('Could not get user verification status. Try again!');
    }
  }

  @override
  Future<void> setEmailVerificationStatus({
    required String userID,
    required bool isVerified,
  }) async {
    try {
      await _fireStore
          .collection(userVerificationCollection)
          .doc(userID)
          .set({userVerificationStatus: isVerified});
    } catch (e) {
      apiService.log.d(e);
      throw Exception('Could not update user verification status. Try again!');
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
    try {
      await _fireStore
          .collection(chatCollection)
          .doc(userID)
          .collection(chatCollection)
          .doc(chatID)
          .set(
        {
          chatNameField: chatName,
          lastActiveField: Timestamp.now().millisecondsSinceEpoch,
          messagesField: FieldValue.arrayUnion(
            messages.map((e) => e.toAPIJson()).toList(),
          ),
        },
        SetOptions(
          merge: merge,
        ),
      );
    } catch (e) {
      apiService.log.d(e);
      throw Exception('Could not update user verification status. Try again!');
    }
  }

  @override
  Future<List<Conversation>> getLastChats({
    required String userID,
    int? lastTimeConversationTimestamp,
    int start = 0,
    int limit = 10,
  }) async {
    try {
      var query = _fireStore
          .collection(chatCollection)
          .doc(userID)
          .collection(chatCollection)
          .orderBy(lastActiveField, descending: true)
          .limit(limit);
      if (lastTimeConversationTimestamp != null) {
        query = query.startAfter([lastTimeConversationTimestamp]);
      }
      final result = await query.get();
      final conversations = <Conversation>[];
      for (final doc in result.docs) {
        apiService.log.d(doc.data());
        conversations.add(Conversation.fromJson(json: doc.data(), id: doc.id));
      }
      return conversations;
    } catch (e) {
      apiService.log.d(e);
      throw Exception('Could not get last chats. Try again!');
    }
  }
}
