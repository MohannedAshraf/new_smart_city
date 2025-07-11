// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_register.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:citio/screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  OutlineInputBorder myBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCFCFCF)),
    );
  }

  Future<void> registerUser() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiRegisterHelper.registerUser(
        fullName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        address: addressController.text.trim(),
        buildingNumber: buildingController.text.trim(),
        floorNumber: floorController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.otpSend, style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VerificationScreen(
                  email: emailController.text.trim(),
                  sourcepage: 'register',
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.accountFailed)));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/icon/citio.svg",
                    height: media.height * 0.12,
                  ),
                  SizedBox(height: media.height * 0.02),
                  Text(
                    AppStrings.register,
                    style: TextStyle(
                      fontSize: media.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Text(
                    AppStrings.registerSubtitle,
                    style: TextStyle(
                      fontSize: media.width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: media.height * 0.025),

                  buildTextField(
                    nameController,
                    AppStrings.fullName,
                    Icons.person,
                    AppStrings.enterName,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    phoneController,
                    AppStrings.phone,
                    Icons.phone,
                    AppStrings.enterPhone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  buildTextField(
                    emailController,
                    AppStrings.email,
                    Icons.email,
                    AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: AppStrings.password,
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                      ),
                      border: myBorder(),
                      enabledBorder: myBorder(),
                      focusedBorder: myBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterPassword;
                      }
                      if (value.length < 6) return AppStrings.passwordTooShort;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  buildTextField(
                    addressController,
                    AppStrings.address,
                    Icons.location_on,
                    AppStrings.enterAddress,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          buildingController,
                          AppStrings.buildingNumber,
                          Icons.apartment,
                          null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildTextField(
                          floorController,
                          AppStrings.floorNumber,
                          Icons.stairs,
                          null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: media.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) registerUser();
                      },
                      child: Text(
                        _isLoading
                            ? AppStrings.registering
                            : AppStrings.registerNow,
                        style: TextStyle(
                          fontSize: media.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.alreadyHaveAccount),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyloginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          AppStrings.login,
                          style: TextStyle(color: MyColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    String? validationMessage, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: myBorder(),
        enabledBorder: myBorder(),
        focusedBorder: myBorder(),
      ),
      validator: (value) {
        if (validationMessage != null && (value == null || value.isEmpty)) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
