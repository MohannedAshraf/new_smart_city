// lib/screens/chat_screen.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  final int orderId;
  final String sellerId;

  const ChatScreen({super.key, required this.orderId, required this.sellerId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();

    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_typingAnimationController);
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = prefs.getString('chat_history_${widget.orderId}');
    if (chatData != null) {
      final List<dynamic> decoded = jsonDecode(chatData);
      setState(() {
        _messages.addAll(decoded.map((e) => ChatMessage.fromJson(e)).toList());
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_messages.map((e) => e.toJson()).toList());
    await prefs.setString('chat_history_${widget.orderId}', encoded);
  }

  void _sendMessage(String msg) async {
    if (msg.trim().isEmpty) return;

    final userMessage = ChatMessage(
      sender: AppStrings.you,
      content: msg.trim(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    _controller.clear();
    await _saveChatHistory();

    // بعد 5 ثواني يظهر vendor بيكتب، وبعدها بثانيتين يرد
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isTyping = true;
      });

      Future.delayed(const Duration(seconds: 5), () {
        String reply;
        final lower = msg.toLowerCase().trim();

        if (lower == 'السلام عليكم') {
          reply = 'وعليكم السلام ورحمة الله وبركاته ';
        } else if (lower.contains('الاوردر متأخر') || lower.contains('متاخر')) {
          reply = 'آسف جدًا، الطلب في الطريق وهيوصللك قريب إن شاء الله ';
        } else if (lower.contains('مشكل') || lower.contains('الطلب فيه')) {
          reply = ' هنتواصل معاك حالًا ونحل المشكلة';
        } else if (lower.contains('فين الطلب') ||
            lower.contains('الطلب راح فين') ||
            (lower.contains("الاوردر  متاخر")) ||
            (lower.contains("الاوردر  موصلش "))) {
          reply = 'آسف جدًا، الطلب في الطريق وهيوصللك قريب إن شاء الله ';
        } else if (lower.contains('مفيش خصم') || lower.contains('الخصم')) {
          reply = 'في عروض جديده الاسبوع القادم  تابعنا    ';
        } else if (lower.contains('تمام') || lower.contains('شكرا')) {
          reply = 'العفو يا فندم إحنا في خدمتك دايمًا ';
        } else if (lower.contains('الدعم') || lower.contains('اكلم مين')) {
          reply = 'سيتواصل الدعم الفني معك  ';
        } else {
          reply = 'هنبعتلك حد من الفريق يتواصل مع حضرتك في أقرب وقت';
        }

        final vendorMessage = ChatMessage(sender: 'vendor', content: reply);
        setState(() {
          _isTyping = false;
          _messages.add(vendorMessage);
        });
        _saveChatHistory();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة مع البائع'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FadeTransition(
                        opacity: _typingAnimation,
                        child: const Text(
                          '...البائع بيكتب',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg.sender == AppStrings.you;

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
                    child: Text(
                      msg.content,
                      style: const TextStyle(fontSize: 16),
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
                      hintText: 'اكتب رسالتك هنا...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_controller.text.trim()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
