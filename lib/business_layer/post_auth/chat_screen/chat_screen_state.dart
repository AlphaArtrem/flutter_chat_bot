part of 'chat_screen_bloc.dart';

///Abstract state for [ChatScreenBloc]
abstract class ChatScreenState extends Equatable {
  const ChatScreenState({
    this.messages = const [],
    this.isLoading = false,
  });

  final List<ChatMessage> messages;

  ///[isLoading] determines weather to show a loading state to user
  final bool isLoading;

  ChatScreenState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
      ];
}

///Initial state for [ChatScreenBloc]
class ChatScreenStateInitial extends ChatScreenState {
  const ChatScreenStateInitial({
    super.messages,
    super.isLoading,
  });

  @override
  ChatScreenState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatScreenStateInitial(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
      ];
}

///Ongoing chat state for [ChatScreenBloc]
class ChatScreenStateInProgress extends ChatScreenState {
  const ChatScreenStateInProgress({
    required super.messages,
    required this.id,
    required this.name,
    this.loadedMessagesLength = 0,
    super.isLoading,
  });

  final String id;
  final String name;
  final int loadedMessagesLength;

  @override
  ChatScreenState copyWith({
    List<ChatMessage>? messages,
    String? id,
    String? name,
    int? loadedMessagesLength,
    bool? isLoading,
  }) {
    return ChatScreenStateInProgress(
      messages: messages ?? this.messages,
      id: id ?? this.id,
      name: name ?? this.name,
      loadedMessagesLength: loadedMessagesLength ?? this.loadedMessagesLength,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        id,
        name,
        loadedMessagesLength,
        isLoading,
      ];
}
