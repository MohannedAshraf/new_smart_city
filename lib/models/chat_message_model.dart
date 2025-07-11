class ChatMessage {
  final String senderId;
  final String content;
  final DateTime time;
  final String senderRole;

  ChatMessage({
    required this.senderId,
    required this.content,
    required this.time,
    required this.senderRole,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['sender']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      time: _parseDate(json['time']),
      senderRole: json['senderRole']?.toString() ?? '',
    );
  }

  factory ChatMessage.fromApiJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId']?.toString() ?? '',
      content: json['messageText']?.toString() ?? '',
      time: _parseDate(json['messageDate']),
      senderRole: json['senderRole']?.toString() ?? '',
    );
  }

  static DateTime _parseDate(dynamic input) {
    try {
      return DateTime.parse(input.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': senderId,
      'content': content,
      'time': time.toIso8601String(),
      'senderRole': senderRole,
    };
  }
}
