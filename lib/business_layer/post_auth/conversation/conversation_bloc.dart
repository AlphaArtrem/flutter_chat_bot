import 'dart:async';
import 'package:chatgpt/data_layer/models/chat/conversation.dart';
import 'package:chatgpt/presentation_layer/post_auth/home/chat_screen.dart';
import 'package:chatgpt/repository_layer/chat_repository/chat_repository_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_events.dart';
part 'conversation_state.dart';

///[Bloc] for [ChatScreen]
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ///[ConversationBloc] default constructor which takes in [ConversationState]
  ///as a required parameter
  ConversationBloc(this.chatRepository)
      : super(const ConversationStateInitial()) {
    on<ConversationEventLoad>(_load);
    on<ConversationEventUpdate>(
      (event, emit) => emit(
        ConversationStateLoaded(
          conversations: event.conversations,
        ),
      ),
    );
  }

  ///Instance for Implementation of [IChatRepository] for chat
  ///completion
  final IChatRepository chatRepository;

  Future<void> _load(
    ConversationEventLoad event,
    Emitter<ConversationState> emit,
  ) async {
    if (state.isLoading) {
      return;
    }
    try {
      emit(state.copyWith(error: '', isLoading: true));
      final conversations = await chatRepository.getLastChats(
        userID: event.userID,
        lastTimeConversationTimestamp: state is ConversationStateLoaded &&
                (state as ConversationStateLoaded).conversations.isNotEmpty
            ? (state as ConversationStateLoaded).conversations.last.lastActive
            : null,
        limit: 20,
      );
      if (state is ConversationStateLoaded) {
        emit(
          ConversationStateLoaded(
            conversations: [
              ...(state as ConversationStateLoaded).conversations,
              ...conversations,
            ],
          ),
        );
      } else {
        emit(
          ConversationStateLoaded(
            conversations: conversations,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
  }
}
