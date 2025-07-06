import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/screens/social_media.dart';

class SocialmediaInitializerScreen extends StatefulWidget {
  const SocialmediaInitializerScreen({super.key});

  @override
  State<SocialmediaInitializerScreen> createState() => _SocialmediaInitializerScreenState();
}

class _SocialmediaInitializerScreenState extends State<SocialmediaInitializerScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _initializeSocialUser();
  }

  Future<void> _initializeSocialUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Missing token.');
      }

      final response = await http.post(
        Uri.parse('${Urls.SocialBaseUrl}users/record'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final message = json['message'] ?? '';

        if (message == 'User recorded successfully' || message == 'User already recorded') {
          await prefs.setBool('isSocialUserInitialized', true);
          _stopwatch.stop();
          debugPrint('⏱️ تم التهيئة في ${_stopwatch.elapsedMilliseconds}ms');

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SocialMedia()),
          );
          return;
        }

        throw Exception('Unexpected server message.');
      }

      throw Exception('Server error: ${response.statusCode}');
    } catch (e) {
      _stopwatch.stop();
      debugPrint('❌ خطأ بعد ${_stopwatch.elapsedMilliseconds}ms: $e');

      if (!mounted) return;
      setState(() {
        _errorMessage = "حدث خطأ أثناء تجهيز حساب السوشيال. حاول مرة أخرى.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جارٍ تجهيز حساب السوشيال الخاص بك...'),
                ],
              )
            : _errorMessage != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          _stopwatch.reset();
                          _stopwatch.start();
                          _initializeSocialUser();
                        },
                        child: const Text('إعادة المحاولة'),
                      )
                    ],
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}
