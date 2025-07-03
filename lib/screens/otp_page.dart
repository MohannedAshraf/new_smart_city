// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously

import 'package:citio/helper/api_otp.dart';
import 'package:citio/screens/new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewPasswordPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل التحقق: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('رمز التحقق')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Center(
              child: Text(
                'أدخل رمز التحقق المكون من 4 أرقام',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 20.h),
            PinCodeTextField(
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
                activeColor: Colors.blue,
                selectedColor: Colors.orange,
                inactiveColor: Colors.grey,
              ),
              enableActiveFill: true,
              onChanged: (value) {},
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "إعادة إرسال الرمز",
                style: TextStyle(
                  fontSize: 14.sp,
                  decoration: TextDecoration.underline,
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
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "ارسال",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
