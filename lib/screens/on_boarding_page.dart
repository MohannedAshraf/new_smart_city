import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/custom_button.dart';
import 'package:city/screens/mylogin_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Smart City",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.green,
              ),
            ),
            const SizedBox(height: 100),
            Container(
              width: 250,
              height: 250,
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(MyAssetsImage.start)),
              ),
            ),
            const SizedBox(height: 40),
            const MyTextButton(text: "Let's Start", newscreen: MyloginPage()),
          ],
        ),
      ),
    );
  }
}
