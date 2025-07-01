import 'package:citio/screens/otp_page.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("نسيت كلمة المرور ")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.0625),
            Text(
              "البريد الالكتروني  ",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02250,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: myBorder(context),
                enabledBorder: myBorder(context),
                focusedBorder: myBorder(context),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'يرجى إدخال بريد إلكتروني صالح';
                }
                return null;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
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
                      builder: (context) => const VerificationScreen(),
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

OutlineInputBorder myBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      MediaQuery.of(context).size.width * 0.0375,
    ),
    borderSide: const BorderSide(
      color: Colors.grey, // لون البوردر أسود ثابت
    ),
  );
}
