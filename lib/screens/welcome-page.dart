// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/screens/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, String>> pages = [
    {
      'image': MyAssetsImage.citio11,
      'title': AppStrings.page1Title,
      'subtitle': AppStrings.page1Subtitle,
    },
    {
      'image': MyAssetsImage.citio12,
      'title': AppStrings.page2Title,
      'subtitle': AppStrings.page2Subtitle,
    },
    {
      'image': MyAssetsImage.citio13,
      'title': AppStrings.page3Title,
      'subtitle': AppStrings.page3Subtitle,
    },
    {
      'image': MyAssetsImage.citio14,
      'title': AppStrings.page4Title,
      'subtitle': AppStrings.page4Subtitle,
    },
    {
      'image': MyAssetsImage.citio15,
      'title': AppStrings.page5Title,
      'subtitle': AppStrings.page5Subtitle,
    },
    {
      'image': MyAssetsImage.citio16,
      'title': AppStrings.page6Title,
      'subtitle': AppStrings.page6Subtitle,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < pages.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.025),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () async {
                    await _completeOnboarding();
                  },
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.05,
                              ),
                              child: Image.asset(
                                pages[index]['image']!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.020),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  pages[index]['title']!,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.055,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.013),
                                Text(
                                  pages[index]['subtitle']!,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.030,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.012,
                    ),
                    width: _currentIndex == index ? 12 : 8,
                    height: _currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index ? Colors.black : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.025,
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_currentIndex == pages.length - 1) {
                      await _completeOnboarding();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == pages.length - 1
                        ? AppStrings.done
                        : AppStrings.next,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
