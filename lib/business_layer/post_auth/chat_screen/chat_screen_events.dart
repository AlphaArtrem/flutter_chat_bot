part of 'chat_screen_bloc.dart';

///Events for [ChatScreenBloc]
abstract class ChatScreenEvent extends Equatable {
  ///Constructor for [ChatScreenEvent]
  const ChatScreenEvent();
}

///Start new chat Event for [ChatScreenBloc]
class ChatScreenEventNewChat extends ChatScreenEvent {
  ///Constructor for [ChatScreenEventNewChat]
  const ChatScreenEventNewChat();

  @override
  List<Object?> get props => [];
}

///Add message Event for [ChatScreenBloc]
class ChatScreenEventAddMessage extends ChatScreenEvent {
  ///Constructor for [ChatScreenEventAddMessage]
  const ChatScreenEventAddMessage({
    required this.chatMessage,
    required this.userID,
    this.onMessageAdded,
    this.onBotMessageGenerated,
  });

  ///Callback for when this message is emitted
  final VoidCallback? onMessageAdded;

  ///Callback for when a bot response is genered for this message
  final VoidCallback? onBotMessageGenerated;

  ///Message to add
  final ChatMessage chatMessage;

  ///User id to save message to user account
  final String userID;
  @override
  List<Object?> get props => [
        chatMessage,
        onMessageAdded,
        userID,
      ];
}

class ChatScreenEventLoadConversation extends ChatScreenEvent {
  ///Constructor for [ChatScreenEventLoadConversation]
  const ChatScreenEventLoadConversation({
    required this.conversation,
    this.onConversationLoaded,
  });

  final Conversation conversation;
  final VoidCallback? onConversationLoaded;

  @override
  List<Object?> get props => [
        conversation,
      ];
}

class ChatScreenEventRegenerateResponse extends ChatScreenEvent {
  ///Constructor for [ChatScreenEventRegenerateResponse]
  const ChatScreenEventRegenerateResponse({
    required this.index,
    required this.userID,
  });

  ///Index of the chat message
  final int index;

  ///User id to save update to user account
  final String userID;

  @override
  List<Object?> get props => [
        index,
        userID,
      ];
}
