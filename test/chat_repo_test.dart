import 'dart:convert';
import 'dart:io';
import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'repository/auth_repository_dummy.dart';
import 'repository/chat_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString());
  test('Auth Repo Test', () async {
    final chatRepositoryDummy = ChatRepositoryDummy(
      json as Map<String, dynamic>,
    );
    final authRepositoryDummy = AuthRepositoryDummy(
      json['userData'] as Map<String, dynamic>,
    );
    final user = await authRepositoryDummy.loginWithGoogle();
    final chats =
        await chatRepositoryDummy.getLastChats(userID: user.userId, limit: 2);

    expect(
      chats.length,
      equals(2),
      reason: 'List of chats fetched should be equal to limit, 2 in this case',
    );

    expect(
      (await chatRepositoryDummy.getNextMessageInChat(
        messages: chats.first.messages,
      ))
          .role,
      equals(ChatMessageRole.assistant),
      reason: 'Chat message response should be from assistant bot',
    );

    await chatRepositoryDummy.saveChat(
      userID: user.userId,
      chatID: 'newChat',
      chatName: 'chatName',
      messages: chats.first.messages,
    );
    expect(
      (await chatRepositoryDummy.getLastChats(userID: user.userId, limit: 10))
          .first
          .chatName,
      equals('chatName'),
      reason: 'New chats should be added at the start',
    );
  });
}
