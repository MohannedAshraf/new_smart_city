// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_reset_password.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:citio/screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: MyColors.white,
        title: const Text(
          AppStrings.resetPasswordTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.06),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: media.height * 0.02),
              Center(
                child: SvgPicture.asset(
                  "assets/icon/citio.svg",
                  height: media.height * 0.15,
                ),
              ),
              SizedBox(height: media.height * 0.01),
              Center(
                child: Text(
                  AppStrings.enterEmailToChangePassword,
                  style: TextStyle(
                    fontSize: media.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: media.height * 0.02),
              Text(
                AppStrings.emailLabel,
                style: TextStyle(
                  fontSize: media.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: media.height * 0.01),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: AppStrings.emailHint,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: media.width * 0.04,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: MyColors.primary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.04,
                    vertical: media.height * 0.02,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade500),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: MyColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.emailRequired;
                  }
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return AppStrings.emailInvalid;
                  }
                  return null;
                },
              ),
              SizedBox(height: media.height * 0.03),
              SizedBox(
                width: double.infinity,
                height: media.height * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: MyColors.primary.withOpacity(0.5),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => isLoading = true);
                              try {
                                final response =
                                    await ResetPasswordApi.sendVerificationOtp(
                                      emailController.text.trim(),
                                    );

                                if (response.isSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(AppStrings.otpSentSuccess),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => VerificationScreen(
                                            email: emailController.text.trim(),
                                            sourcePage: 'reset password',
                                          ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(AppStrings.otpSendFailed),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${AppStrings.errorOccurred} $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            AppStrings.send,
                            style: TextStyle(
                              fontSize: media.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              SizedBox(height: media.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.rememberPassword,
                    style: TextStyle(
                      fontSize: media.width * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: media.width * 0.01),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyloginPage()),
                      );
                    },
                    child: Text(
                      AppStrings.login,
                      style: TextStyle(
                        fontSize: media.width * 0.035,
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: media.height * 0.03),
              Center(
                child: Text(
                  AppStrings.poweredBy,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: media.width * 0.035,
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.01),
              Center(
                child: Text(
                  AppStrings.version,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: media.width * 0.032,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
