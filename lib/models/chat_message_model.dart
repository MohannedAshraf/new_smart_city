// lib/models/chat_message_model.dart

class ChatMessage {
  final String sender;
  final String content;

  ChatMessage({required this.sender, required this.content});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(sender: json['sender'], content: json['content']);
  }

  Map<String, dynamic> toJson() {
    return {'sender': sender, 'content': content};
  }
}
