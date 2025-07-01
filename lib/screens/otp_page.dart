// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('رمز التحقق')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Center(
              child: Text(
                'أدخل رمز التحقق المكون من 4 أرقام',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            // ignore: prefer_const_constructors
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
              onChanged: (value) {
                // ignore: avoid_print
                print("Current PIN: $value");
              },
              onCompleted: (code) {
                // ignore: avoid_print
                print("Completed: $code");
                // هنا تحقق من الكود أو أرسله للسيرفر
              },
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                "اعادة ارسال الرمز",
                style: TextStyle(
                  fontSize: 14.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.r),
              ),
              width: double.infinity,
              height: 50.h,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyloginPage(),
                    ),
                  );
                },
                child: Text(
                  "ارسال",
                  style: TextStyle(
                    fontSize: 28.sp,
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
