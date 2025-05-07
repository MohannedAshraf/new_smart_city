import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/custom_button.dart';

import 'package:city/core/widgets/socialmedia_tab_view.dart';
import 'package:city/core/widgets/vendor_profile.dart';

import 'package:city/core/widgets/tab_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://x.com/home');

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  //const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Icon(
          Icons.groups_2_outlined,
          color: MyColors.themecolor,
          size: 26,
        ),
        centerTitle: true,
        //  excludeHeaderSemantics: true,
        backgroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
      ),
      body: SocialmediaTabView(),
    );
  }
}
