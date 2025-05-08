// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:citio/core/utils/variables.dart';

import 'package:citio/core/widgets/socialmedia_tab_view.dart';

import 'package:flutter/material.dart';

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
      body: const SocialmediaTabView(),
    );
  }
}
