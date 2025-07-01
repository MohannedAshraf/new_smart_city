import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/auth_helper.dart';
import 'package:citio/main.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final success = await AuthHelper.refreshTokenIfNeeded();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => success ? const HomePage() : const MyloginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.625,
          height: MediaQuery.of(context).size.height * 0.3125,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.0250,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MyAssetsImage.city),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
