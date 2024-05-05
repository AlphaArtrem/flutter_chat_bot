import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/repository_layer/chat_repository/chat_repository_interface.dart';
import 'package:chatgpt/service_layer/service_locator.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_screen_events.dart';
part 'chat_screen_state.dart';

///[Bloc] for [ChatScreen]
class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  ///[ChatScreenBloc] default constructor which takes in [ChatScreenState]
  ///as a required parameter
  ChatScreenBloc(this.chatRepository, {this.isTest = false})
      : super(const ChatScreenStateInitial()) {
    on<ChatScreenEventNewChat>(
      (event, emit) => emit(const ChatScreenStateInitial()),
    );
    on<ChatScreenEventAddMessage>(_addMessage);
    on<ChatScreenEventLoadConversation>(_loadConversation);
    on<ChatScreenEventRegenerateResponse>(_regenerate);
  }

  ///Instance for Implementation of [IChatRepository] for chat
  ///completion
  final IChatRepository chatRepository;

  ///If running a test turn off MD5 hashing
  final bool isTest;

  Future<void> _loadConversation(
    ChatScreenEventLoadConversation event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(
      ChatScreenStateInProgress(
        messages: event.conversation.messages,
        id: event.conversation.id,
        name: event.conversation.chatName,
        loadedMessagesLength: event.conversation.messages.length,
      ),
    );
    event.onConversationLoaded?.call();
  }

  Future<void> _addMessage(
    ChatScreenEventAddMessage event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    var messages = [...state.messages, event.chatMessage];
    emit(state.copyWith(messages: messages));

    event.onMessageAdded?.call();
    if (event.chatMessage.role == ChatMessageRole.user) {
      try {
        final reply = await chatRepository.getNextMessageInChat(
          messages: state.messages,
        );
        messages = [...state.messages, reply];
        emit(
          state.copyWith(
            messages: messages,
          ),
        );
        await _getChatNameAndEmitInProgress(event, emit);
        event.onBotMessageGenerated?.call();
      } catch (e) {
        apiService.log.d(e);
      }
    }
    emit(state.copyWith(isLoading: false));
    await _saveChat(event.userID);
  }

  Future<void> _getChatNameAndEmitInProgress(
    ChatScreenEventAddMessage event,
    Emitter<ChatScreenState> emit,
  ) async {
    if (state.messages.length == 2) {
      const chatTopicMessage = 'Give a topic/subject to this '
          'conversation in less than 50 words';
      final messages = [
        ...state.messages,
        const ChatMessage(
          role: ChatMessageRole.system,
          content: chatTopicMessage,
        ),
      ];
      final chatName = await chatRepository.getNextMessageInChat(
        messages: messages,
      );
      final encodingData =
          DateTime.now().millisecondsSinceEpoch.toString() + event.userID;
      emit(
        ChatScreenStateInProgress(
          messages: state.messages,
          id: isTest
              ? event.userID
              : md5.convert(utf8.encode(encodingData)).toString(),
          name: chatName.content.length > 50
              ? chatName.content.substring(0, 50)
              : chatName.content,
        ),
      );
    }
  }

  Future<void> _saveChat(String userID, {bool merge = true}) async {
    if (state is ChatScreenStateInProgress && state.messages.length >= 2) {
      try {
        final state = this.state as ChatScreenStateInProgress;
        await chatRepository.saveChat(
          merge: merge,
          userID: userID,
          chatID: state.id,
          chatName: state.name,
          messages: merge
              ? [
                  state.messages[state.messages.length - 2],
                  state.messages.last,
                ]
              : state.messages,
        );
      } catch (e) {
        apiService.log.d(e);
      }
    }
  }

  Future<void> _regenerate(
    ChatScreenEventRegenerateResponse event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    if (state.messages[event.index].role == ChatMessageRole.assistant) {
      try {
        final reply = await chatRepository.getNextMessageInChat(
          messages: state.messages.sublist(0, event.index),
        );
        final messages = [...state.messages]
          ..removeAt(event.index)
          ..insert(event.index, reply);
        emit(
          state.copyWith(
            messages: messages,
          ),
        );
        await _saveChat(event.userID, merge: false);
      } catch (e) {
        apiService.log.d(e);
      }
    }
    emit(state.copyWith(isLoading: false));
  }
}
