// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:city/core/widgets/custom_button.dart';
import 'package:city/main.dart';
//import 'package:city/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyloginPage extends StatefulWidget {
  const MyloginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyloginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _isLoading = false;

  // ✅ دالة تسجيل الدخول والتعامل مع التوكن
  Future<void> loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _validate = true);
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(
      "https://cms-central-ffb6acaub5afeecj.uaenorth-01.azurewebsites.net/api/auth/login",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String? token = responseData["value"]?["token"];

        if (token != null) {
          // ignore: unused_element
          void saveToken(String token) async {
            final SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setString('token', token);
            // ignore: duplicate_ignore
            // ignore: avoid_print
            print("✅ Token Saved: $token");
          }

          // ✅ نجاح تسجيل الدخول → الانتقال للصفحة الرئيسية
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } else {
          throw Exception("التوكن غير موجود في الاستجابة!");
        }
      } else {
        // ❌ فشل تسجيل الدخول
        final responseData = jsonDecode(response.body);
        String errorMessage =
            responseData["message"] ?? "حدث خطأ أثناء تسجيل الدخول";

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (error) {
      setState(() => _isLoading = false);

      print("❌ Error: $error");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل الاتصال بالخادم، حاول مرة أخرى!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode:
                _validate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Smart City',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'يرجى إدخال بريد إلكتروني صالح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                MyTextButton(
                  text: _isLoading ? "جاري التحقق..." : "تسجيل الدخول",
                  onPressed: () => loginUser(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
