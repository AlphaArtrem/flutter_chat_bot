import 'package:chatgpt/data_layer/models/chat/chat_message_role.dart';
import 'package:equatable/equatable.dart';

///[ChatMessage] class contains data for each messages send by user and
///response received by user, including any error
class ChatMessage extends Equatable {
  ///Constructor for [ChatMessage]
  const ChatMessage({
    required this.role,
    required this.content,
    this.isError = false,
  });

  ///Get [ChatMessage] from JSON stored on BE
  factory ChatMessage.fromJson(
    Map<String, dynamic> json,
  ) {
    final role = ChatMessageRole.values
        .where((element) => element.name == json['role'].toString());
    return ChatMessage(
      role: role.isNotEmpty ? role.first : ChatMessageRole.unknown,
      content: json['content'] is String ? json['content'].toString() : '',
    );
  }

  ///Role of sender
  final ChatMessageRole role;

  ///The textual content of message
  final String content;

  ///Was this an error
  final bool isError;

  ///Copy with constructor
  ChatMessage copyWith({
    ChatMessageRole? role,
    String? content,
    bool? isError,
  }) {
    return ChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      isError: isError ?? this.isError,
    );
  }

  ///Convert thus to JSON for API usage
  Map<String, dynamic> toAPIJson() {
    final map = <String, dynamic>{};
    map['role'] = role.name;
    map['content'] = content;
    return map;
  }

  @override
  List<Object?> get props => [
        role,
        content,
        isError,
      ];
}
