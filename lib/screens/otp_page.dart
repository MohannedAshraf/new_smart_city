// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously

import 'dart:async';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_otp.dart';
import 'package:citio/helper/api_reset_password.dart';
import 'package:citio/main.dart';
import 'package:citio/screens/new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String sourcepage;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.sourcepage,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _pinController = TextEditingController();
  bool isLoading = false;
  bool isResending = false;
  int _secondsLeft = 0;
  Timer? _timer;

  void _startCountdown() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsLeft--;
        if (_secondsLeft == 0) timer.cancel();
      });
    });
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);
    try {
      final response = await ResetPasswordApi.sendVerificationOtp(widget.email);
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.otpResentSuccess),
            backgroundColor: Colors.green,
          ),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.otpResentFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.errorOccurred1),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isResending = false);
    }
  }

  void _submitOtp() async {
    final otp = _pinController.text.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.enter4Digits),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await VerifyOtpApi.verifyOtp(email: widget.email, otp: otp);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.otpVerifiedSuccess),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.sourcepage == "login" || widget.sourcepage == "register") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (widget.sourcepage == "reset password") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewPasswordPage()),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.verifyOtpError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  String obscureEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 1) return '$username@$domain';
    final stars = '*' * (username.length - 1);
    return '${username[0]}$stars@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(centerTitle: true, title: const Text(AppStrings.otpCode)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.02),
            Center(
              child: SvgPicture.asset(
                "assets/icon/citio.svg",
                height: height * 0.18,
              ),
            ),
            Text(
              AppStrings.enterOtp,
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              AppStrings.sentOtpToEmail,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: width * 0.035,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              obscureEmail(widget.email),
              style: TextStyle(fontSize: width * 0.037, color: Colors.black87),
            ),
            SizedBox(height: height * 0.025),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: width * 0.65,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(width * 0.025),
                    fieldHeight: height * 0.065,
                    fieldWidth: width * 0.12,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: MyColors.primary,
                    selectedColor: MyColors.primary,
                    inactiveColor: Colors.grey[300]!,
                  ),
                  enableActiveFill: true,
                  onChanged: (value) {},
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            SizedBox(
              width: double.infinity,
              height: height * 0.065,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          AppStrings.send,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              AppStrings.didNotReceiveOtp,
              style: TextStyle(fontSize: width * 0.045),
            ),
            TextButton(
              onPressed: (_secondsLeft > 0 || isResending) ? null : _resendOtp,
              child: Text(
                (_secondsLeft > 0)
                    ? "${AppStrings.resendIn} $_secondsLeft ${AppStrings.seconds}"
                    : AppStrings.resendOtp,
                style: TextStyle(
                  fontSize: width * 0.04,
                  color: (_secondsLeft > 0) ? Colors.grey : MyColors.primary,
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            Text(
              AppStrings.poweredBy,
              style: TextStyle(color: Colors.black, fontSize: width * 0.04),
            ),
            Text(
              AppStrings.version,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: width * 0.035,
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
