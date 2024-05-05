part of 'conversation_bloc.dart';

///Events for [ConversationBloc]
abstract class ConversationEvent extends Equatable {
  ///[ConversationEvent] default constructor
  const ConversationEvent();
}

///Event to reset data for [ConversationBloc]
class ConversationEventReset extends ConversationEvent {
  ///[ConversationEventReset] default constructor
  const ConversationEventReset();

  @override
  List<Object?> get props => [];
}

///Event to load data for [ConversationBloc]
class ConversationEventLoad extends ConversationEvent {
  ///[ConversationEventLoad] default constructor
  const ConversationEventLoad({required this.userID});

  ///[userID] contains details of logged in user
  final String userID;

  @override
  List<Object?> get props => [userID];
}

///Update conversations [ConversationBloc]
class ConversationEventUpdate extends ConversationEvent {
  ///[ConversationEventUpdate] default constructor
  const ConversationEventUpdate({required this.conversations});

  ///[conversations] to replace current conversations with
  final List<Conversation> conversations;

  @override
  List<Object?> get props => [conversations];
}
