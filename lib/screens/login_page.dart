import 'package:city/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false; // حالة تفعيل "تذكرني"

  void loginUser() {
    if (_formKey.currentState?.validate() ?? false) {
      // إذا كانت البيانات صحيحة، انتقل إلى الصفحة الرئيسية
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(
                 
                )),
      );
    }
  }

  void forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController forgotEmailController =
            TextEditingController();

        return AlertDialog(
          title: const Text(
            'نسيت كلمة المرور',
            textDirection: TextDirection.rtl,
          ),
          content: TextField(
            controller: forgotEmailController,
            decoration: const InputDecoration(
              labelText: 'البريد الإلكتروني',
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = forgotEmailController.text.trim();
                if (email.isNotEmpty &&
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(email)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم إرسال رابط تغيير كلمة المرور إلى بريدك الإلكتروني.',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى إدخال بريد إلكتروني صالح.',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Smart City',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D6643),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                border: OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.rtl,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى إدخال البريد الإلكتروني';
                                }
                                final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
                              textDirection: TextDirection.rtl,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                      value: rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value;
                                        });
                                      },
                                      activeColor: const Color(0xFF3D6643),
                                    ),
                                    const Text(
                                      'تذكرني',
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: forgotPassword,
                                  child: const Text(
                                    'نسيت كلمة المرور؟',
                                    style: TextStyle(color: Color(0xFF3D6643)),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: loginUser,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF3D6643),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('تسجيل الدخول'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
