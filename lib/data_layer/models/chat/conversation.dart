import 'package:chatgpt/data_layer/models/chat/chat_message.dart';
import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.chatName,
    required this.lastActive,
    required this.messages,
  });

  factory Conversation.fromJson({
    required Map<String, dynamic> json,
    required String id,
  }) {
    return Conversation(
      id: id,
      chatName: json['chatName'] is String ? json['chatName'].toString() : '',
      lastActive: json['lastActive'] is int ? json['lastActive'] as int : 0,
      messages: json['messages'] is List
          ? (json['messages'] as List)
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  final String id;
  final String chatName;
  final int lastActive;
  final List<ChatMessage> messages;

  Conversation copyWith({
    String? id,
    String? chatName,
    int? lastActive,
    List<ChatMessage>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      chatName: chatName ?? this.chatName,
      lastActive: lastActive ?? this.lastActive,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toAPIJson() {
    final map = <String, dynamic>{};
    map['chatName'] = chatName;
    map['lastActive'] = lastActive;
    map['messages'] = messages.map((e) => e.toAPIJson());
    return map;
  }

  @override
  List<Object?> get props => [
        id,
        chatName,
        lastActive,
        messages,
      ];
}
