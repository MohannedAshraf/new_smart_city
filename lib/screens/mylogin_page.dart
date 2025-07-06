// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_login.dart';
import 'package:citio/helper/api_profile.dart';
import 'package:citio/main.dart';
import 'package:citio/screens/register_page.dart';
import 'package:citio/screens/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citio/services/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
          final profile = await ApiProfileHelper.fetchProfile();
          await prefs.setString('userId', profile!.id ?? '');
        } catch (e) {
          print("❌ فشل في تحميل البروفايل: $e");
        }

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
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
              child: Form(
                key: _formKey,
                autovalidateMode:
                    _validate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/icon/citio.svg",
                        height: screenHeight * 0.15,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        AppStrings.welcomeBack,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        AppStrings.loginSubText,
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Email
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          hintText: AppStrings.emailHint,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          border: myBorder(),
                          enabledBorder: myBorder(),
                          focusedBorder: myBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.loginEmailRequired;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password
                      TextFormField(
                        controller: passwordController,

                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          hintText: AppStrings.passwordHint,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
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
                            return AppStrings.loginPasswordRequired;
                          }
                          if (value.length < 6) {
                            return AppStrings.loginPasswordTooShort;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPasswordView(),
                              ),
                            );
                          },
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(
                              fontSize: 15,
                              color: MyColors.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primary,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => loginUser(context),
                          child: Text(
                            _isLoading
                                ? AppStrings.loggingIn
                                : AppStrings.loginButton,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.noAccount,
                            style: TextStyle(fontSize: screenWidth * 0.045),
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
                              AppStrings.register,
                              style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        AppStrings.loginPoweredBy,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.038,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
