// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously

import 'dart:async';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_otp.dart';
import 'package:citio/helper/api_reset_password.dart';
import 'package:citio/screens/new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

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
        if (_secondsLeft == 0) {
          timer.cancel();
        }
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
            content: Text("✅ تم إرسال الرمز مرة أخرى بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ فشل في إرسال الرمز"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ حصل خطأ أثناء محاولة الإرسال"),
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
          content: Text('الرجاء إدخال رمز مكون من 4 أرقام'),
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
          content: Text('✅ تم التحقق من الرمز بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewPasswordPage()),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            " تحقق من الرمز",
            style: TextStyle(color: Colors.white),
          ),
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
    _startCountdown(); // ✅ هنا بالظبط
  }

  String obscureEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 1) {
      // مفيش حاجة تتخبي
      return '$username@$domain';
    }

    // عدد النجوم = طول الاسم - 1
    final stars = '*' * (username.length - 1);
    return '${username[0]}$stars@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('رمز التحقق')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Center(
              child: SvgPicture.asset("assets/icon/citio.svg", height: 120.h),
            ),
            Center(
              child: Text(
                'أدخل رمز التحقق',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "لقد  أرسلنا رمز  مكون  من  4  أرقام  إلي  بريدك  الإلكتروني",
              style: TextStyle(color: Colors.grey[800], fontSize: 13.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              obscureEmail(widget.email),
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
            SizedBox(height: 15.h),

            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width:
                    (40.w * 4) +
                    (20.w * 3), // 4 خانات كل خانة 40 عرض و 3 مسافات بينهم 20
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.r),
                    fieldHeight: 50.h,
                    fieldWidth: 40.w,
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
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "إرسال",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
            SizedBox(height: 15.sp),
            Text("لم  يصلك  الرمز؟", style: TextStyle(fontSize: 18.sp)),
            TextButton(
              onPressed: (_secondsLeft > 0 || isResending) ? null : _resendOtp,
              child: Text(
                (_secondsLeft > 0)
                    ? "إعادة إرسال خلال $_secondsLeft ث"
                    : "إعادة إرسال  الرمز",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: (_secondsLeft > 0) ? Colors.grey : MyColors.primary,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "Powered by Citio",
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                "Version 2.1.0",
                style: TextStyle(color: Colors.grey[800], fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
