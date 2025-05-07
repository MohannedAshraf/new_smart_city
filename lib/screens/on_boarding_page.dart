import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/custom_button.dart';
import 'package:citio/screens/mylogin_page.dart';
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
              "Citio",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.gray,
              ),
            ),
            const SizedBox(height: 100),
            Container(
              width: 250,
              height: 250,
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(MyAssetsImage.city)),
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: MyTextButton(text: "هيا بنا ", newscreen: MyloginPage()),
            ),
          ],
        ),
      ),
    );
  }
}
