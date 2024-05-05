part of 'conversation_bloc.dart';

///Abstract state for [ConversationBloc]
abstract class ConversationState extends Equatable {
  ///[ConversationState] default constructor which can't be invoked due to it
  ///being an abstract class
  const ConversationState({
    this.error = '',
    this.isLoading = false,
  });

  ///[error] to be shown to user during conversation fetch
  final String error;

  ///[isLoading] determines weather to show a loading state to user
  final bool isLoading;

  ///Copy with constructor for [ConversationState]
  ConversationState copyWith({
    String? error,
    bool? isLoading,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
        error,
        isLoading,
      ];
}

///Initial state for [ConversationBloc]
class ConversationStateInitial extends ConversationState {
  const ConversationStateInitial({
    super.error,
    super.isLoading,
  });

  @override
  ConversationStateInitial copyWith({
    String? error,
    bool? isLoading,
  }) {
    return ConversationStateInitial(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
      ];
}

///Loaded state for [ConversationBloc]
class ConversationStateLoaded extends ConversationState {
  const ConversationStateLoaded({
    required this.conversations,
    super.error,
    super.isLoading = false,
  });

  ///Conversation loaded for the database
  final List<Conversation> conversations;

  @override
  ConversationStateLoaded copyWith({
    String? error,
    bool? isLoading,
    List<Conversation>? conversations,
  }) {
    return ConversationStateLoaded(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        conversations,
      ];
}
