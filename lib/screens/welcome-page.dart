// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'package:citio/core/utils/assets_image.dart';
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
      'text': 'أهلاً بك في Citio\nتطبيقك الذكي لحياة أسهل داخل مدينتك.',
    },
    {
      'image': MyAssetsImage.citio12,
      'text':
          'بلّغ عن مشكلة\nصوّر أي مشكلة في المدينة، وسنرسلها فورًا للجهة المختصة.\nتابع الرد، قيّم الحل، وشاركها على وسائل التواصل!',
    },
    {
      'image': MyAssetsImage.citio13,
      'text':
          'خدمات حكومية بين يديك\nكل ما تحتاجه من معاملات وخدمات حكومية متاح الآن في مكان واحد وبسهولة.',
    },
    {
      'image': MyAssetsImage.citio14,
      'text':
          'اكتشف مقدمي الخدمات والمنتجات\nاطّلع على جميع المحلات، الشركات، والخدمات في مدينتك واطلب منها مباشرة من خلال التطبيق.',
    },
    {
      'image': MyAssetsImage.citio15,
      'text':
          'تواصل مع مجتمعك\nتابع آخر الأخبار، شارك رأيك، وكن جزءًا من الحياة الاجتماعية للمدينة.',
    },
    {
      'image': MyAssetsImage.citio16,
      'text': 'جاهز تبدأ؟\nخلينا نغيّر شكل الحياة في المدينة سوا!',
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
          duration: const Duration(milliseconds: 300),
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
    return Scaffold(
      body: Column(
        children: [
          // زر تخطي
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  await _completeOnboarding();
                },
                child: const Text(
                  'تخطي',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
                      child: Image.asset(
                        pages[index]['image']!,
                        width: double.infinity,
                        fit:
                            BoxFit
                                .cover, // تقدر تخليه contain لو عايز تحافظ على الأبعاد الأصلية
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          pages[index]['text']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.black : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // زر التالي أو تم
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                _currentIndex == pages.length - 1 ? 'تم' : 'التالي',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
