// ignore_for_file: library_private_types_in_public_api, unused_element, unused_local_variable

import 'package:citio/core/utils/variables.dart';

import 'package:citio/core/widgets/socialmedia_tab_view.dart';
import 'package:citio/main.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        backgroundColor: MyColors.white,

        surfaceTintColor: MyColors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(initialIndex: 0),
              ),
            );
          },
        ),
        flexibleSpace: Container(height: 0),
        toolbarHeight: 50,

        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Row(
            children: [
              SizedBox(width: screenWidth * .13),
              const Column(
                children: [
                  Text(
                    'آخر المشاركات',
                    style: TextStyle(color: MyColors.black, fontSize: 20),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, color: MyColors.gray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: const SocialmediaTabView(),
    );
  }
}
