import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_chat.dart';
import 'package:citio/helper/api_signalr_helper.dart';
import 'package:citio/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int orderId;
  final String sellerId;

  const ChatScreen({super.key, required this.orderId, required this.sellerId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SignalRService _signalRService = SignalRService();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadOldMessages();
    _initSignalR();
  }

  Future<void> _loadOldMessages() async {
    try {
      final oldMessages = await ApiChatHelper.getOldMessages(
        otherUserId: widget.sellerId,
        orderId: widget.orderId,
      );
      setState(() {
        _messages.addAll(oldMessages);
      });
    } catch (e) {
      print("❌ Failed to load old messages: $e");
    }
  }

  Future<void> _initSignalR() async {
    await _signalRService.initConnection(
      orderId: widget.orderId,
      onMessageReceived: (msg) {
        setState(() {
          _messages.add(msg);
        });
      },
      onError: (error) {
        print("❌ الاتصال اتقفل: $error");
      },
    );
  }

  void _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();

    try {
      await _signalRService.sendMessage(
        orderId: widget.orderId,
        sellerId: widget.sellerId,
        receiverId: widget.sellerId,
        message: trimmed,
      );
    } catch (e) {
      print("❌ إرسال الرسالة فشل: $e");
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time.toLocal());
  }

  @override
  void dispose() {
    _signalRService.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chatWithSeller),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                final msg = _messages[index];
                final isUser = msg.senderRole.toLowerCase() == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.content, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(msg.time),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: AppStrings.writeMessage,
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
