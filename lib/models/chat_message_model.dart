import 'dart:convert';

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
      content: _decodeUtf8(json['content']),
      time: _parseDate(json['time']),
      senderRole: json['senderRole']?.toString() ?? '',
    );
  }

  factory ChatMessage.fromApiJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId']?.toString() ?? '',
      content: _decodeUtf8(json['messageText']),
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

  static String _decodeUtf8(dynamic input) {
    try {
      final bytes = input.toString().codeUnits;
      return utf8.decode(bytes);
    } catch (_) {
      return input.toString();
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
