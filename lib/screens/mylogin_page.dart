// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:citio/helper/api_login.dart';
import 'package:citio/helper/api_profile.dart';
import 'package:citio/main.dart';
import 'package:citio/screens/register_page.dart';
import 'package:citio/screens/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citio/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyloginPage extends StatefulWidget {
  const MyloginPage({super.key});

  @override
  State<MyloginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MyloginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _validate = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiLoginHelper.login(
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result != null && context.mounted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result.token!);
        try {
          await ApiProfileHelper.fetchProfile();
        } catch (e) {
          print("❌ فشل في تحميل البروفايل: $e");
        }
        print('✅Token ${result.token!}');
        await FCMService().initFCM();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
        );
      }
    }
  }

  OutlineInputBorder myBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Form(
              key: _formKey,
              autovalidateMode:
                  _validate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/icon/citio.svg", height: 120.h),
                    SizedBox(height: 16.h),
                    Text(
                      "مرحباً بعودتك",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "سجّل الدخول لإدارة خدمات المدينة",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 24.h),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "البريد الإلكتروني",
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "كلمة المرور",
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordView(),
                            ),
                          );
                        },
                        child: const Text(
                          "هل نسيت كلمة المرور؟",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () => loginUser(context),
                        child: Text(
                          _isLoading ? "جاري التحقق..." : "تسجيل الدخول",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Register Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ليس لديك حساب؟",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "افتح حساب",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),
                    Text(
                      " Powered by Citio\n version 2.1.0",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
