import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
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
    await Future.delayed(const Duration(seconds: 3));
    final success = await AuthHelper.refreshTokenIfNeeded();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => success ? const HomePage() : const MyloginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Container(
          width: screen.width * 0.6,
          height: screen.width * 0.6,
          margin: EdgeInsets.symmetric(
            horizontal: screen.width * 0.05,
            vertical: screen.height * 0.05,
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
