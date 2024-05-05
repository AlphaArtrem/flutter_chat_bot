import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:chatgpt/business_layer/post_auth/chat_screen/chat_screen_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/conversation/conversation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'repository/auth_repository_dummy.dart';
import 'repository/chat_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString());
  final authRepositoryDummy = AuthRepositoryDummy(
    (json as Map<String, dynamic>)['userData'] as Map<String, dynamic>,
  );
  final chatRepositoryDummy = ChatRepositoryDummy(json);
  final user = await authRepositoryDummy.loginWithGoogle();
  final conversations =
      await chatRepositoryDummy.getLastChats(userID: user.userId);
  group('Chat Flow Test', () {
    late ChatScreenBloc chatScreenBloc;
    late ConversationBloc conversationBloc;

    setUp(() {
      chatScreenBloc = ChatScreenBloc(
        chatRepositoryDummy,
        isTest: true,
      );
      conversationBloc = ConversationBloc(chatRepositoryDummy);
    });

    test('Initial Chat Bloc State Test', () {
      expect(
        chatScreenBloc.state,
        equals(const ChatScreenStateInitial()),
        reason: 'Initial ChatScreenBloc state should be ChatScreenStateInitial',
      );

      expect(
        conversationBloc.state,
        equals(const ConversationStateInitial()),
        reason: 'Initial ConversationBloc state should be '
            'ConversationStateInitial',
      );

      expect(
        chatScreenBloc.state.messages.isEmpty,
        equals(true),
        reason: 'Initial ChatScreenBloc messages should be empty',
      );

      expect(
        conversationBloc.state.isLoading,
        equals(true),
        reason: 'Initial ConversationBloc state should be loading',
      );
    });

    blocTest<ChatScreenBloc, ChatScreenState>(
      'Adding a new user message should prompt a response from bot',
      build: () => chatScreenBloc,
      act: (bloc) => bloc.add(
        ChatScreenEventAddMessage(
          chatMessage: conversations.first.messages.first,
          userID: user.userId,
        ),
      ),
      expect: () async => [
        const ChatScreenStateInitial(isLoading: true),
        ChatScreenStateInitial(
          messages: [conversations.first.messages.first],
          isLoading: true,
        ),
        ChatScreenStateInitial(
          messages: [
            conversations.first.messages.first,
            await chatRepositoryDummy.getNextMessageInChat(
              messages: conversations.first.messages,
            ),
          ],
          isLoading: true,
        ),
        ChatScreenStateInProgress(
          messages: [
            conversations.first.messages.first,
            await chatRepositoryDummy.getNextMessageInChat(
              messages: conversations.first.messages,
            ),
          ],
          id: user.userId,
          name: (await chatRepositoryDummy.getNextMessageInChat(
            messages: conversations.first.messages,
          ))
              .content
              .substring(0, 34),
        ),
      ],
    );
  });
}
