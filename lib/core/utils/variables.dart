import 'package:flutter/material.dart';

abstract class MyColors {
  static const Color fontcolor = Color.fromRGBO(0, 0, 0, 1);
  static const Color ambulance = Color(0xFFE53935);
  static const Color ambulanceShade = Color(0x4DE53935);
  static const Color firefighter = Color(0xFFD84315);
  static const Color firefighterShade = Color(0x4DD84315);
  static const Color police = Color(0xFF1E88E5);
  static const Color policeShade = Color(0x4D1E88E5);
  static const Color buttonGreen = Color(0xFF4CAF50);
  static const Color buttonGreenShade = Color(0x4D4CAF50);
  static const Color platinum = Color(0xffE5E4E2);
  static const Color dodgerBlue = Color(0xff1E90FF);
  static const Color oldLace = Color(0xffFFFAFA);
  static const Color whiteSmoke = Color(0xffF5F5F5);
  static const Color ghostColor = Color(0xffF8F8FF);
  static const Color offWhite = Color(0xffFAF9F6);
  static const Color cardcolor = Color.fromARGB(255, 141, 177, 146);
  static const Color themecolor = Color(0xFF3D6643);
  static const Color emergencybuttonscolor = Color(0x803D6643);
  static const Color cardfontcolor = Colors.white;
  static const Color backgroundColor = Color(0xffF3F5F4);
  static const Color red = Color(0xffE4312B);
  static const Color green = Color(0xff149954);
  static const Color white = Color(0xffFFFFFF);
  static const Color forground = Color.fromARGB(255, 248, 183, 183);
  static const Color gray = Color(0xff6E6A7C);
  static const Color grey = Color(0xff777777);
  static const Color fadedGrey = Color(0x1Acdcdcd);
  static const Color black = Color(0xff24252C);
  // ignore: use_full_hex_values_for_flutter_colors
  static const Color gray2 = Color(0xff00000040);
  static const Color mintgreen = Color.fromARGB(255, 193, 233, 213);
  static const Color homecolor = Color.fromARGB(255, 233, 189, 212);
  static const Color pink = Color(0xffFFE4F2);
}

abstract class Urls {
  static const String socialmediaBaseUrl = 'https://graduation.amiralsayed.me';
  static const String serviceProviderbaseUrl =
      'https://service-provider.runasp.net';
  static const String governmentbaseUrl =
      'https://government-services.runasp.net';

  static const issueBaseUrl = 'https://cms-reporting.runasp.net';
}

abstract class Styles {
  static const Map<String, Map<String, dynamic>> govTabStyles = {
    'السجل المدني': {
      'color': Color(0x1A607D8B),
      'icon': Icons.badge,
      'fontColor': Colors.blueGrey,
    },
    'النقل': {
      'color': Color(0x1AFF9800),
      'icon': Icons.directions_bus,
      'fontColor': Colors.orange,
    },
    'الصحة': {
      'color': Color(0x1AFF5252),
      'icon': Icons.local_hospital,
      'fontColor': Colors.redAccent,
    },
    'المالية': {
      'color': Color(0x1A4CAF50),
      'icon': Icons.attach_money,
      'fontColor': Colors.green,
    },
    'التجارة': {
      'color': Color(0x1A673AB7),
      'icon': Icons.shopping_cart,
      'fontColor': Colors.deepPurple,
    },
  };
}
