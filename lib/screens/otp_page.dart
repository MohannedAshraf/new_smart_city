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
        padding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
          vertical: MediaQuery.of(context).size.height * 0.0250,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
            Center(
              child: Text(
                'أدخل رمز التحقق المكون من 4 أرقام',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02250,
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _pinController,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.025,
                ),
                fieldHeight: MediaQuery.of(context).size.height * 0.0625,
                fieldWidth: MediaQuery.of(context).size.width * 0.1,
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
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.025,
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.0625,
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
                    fontSize: MediaQuery.of(context).size.height * 0.0350,
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
