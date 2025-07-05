// ignore_for_file: file_names, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/screens/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      'title': 'أهلاً بك في Citio',
      'subtitle': 'تطبيقك الذكي لحياة أسهل داخل مدينتك.',
    },
    {
      'image': MyAssetsImage.citio12,
      'title': 'بلّغ عن مشكلة',
      'subtitle':
          'صوّر أي مشكلة في المدينة، وسنرسلها فورًا للجهة المختصة.\nتابع الرد، قيّم الحل، وشاركها على وسائل التواصل!',
    },
    {
      'image': MyAssetsImage.citio13,
      'title': 'خدمات حكومية بين يديك',
      'subtitle':
          'كل ما تحتاجه من معاملات وخدمات حكومية متاح الآن في مكان واحد وبسهولة.',
    },
    {
      'image': MyAssetsImage.citio14,
      'title': 'اكتشف مقدمي الخدمات والمنتجات',
      'subtitle':
          'اطّلع على جميع المحلات، الشركات، والخدمات في مدينتك واطلب منها مباشرة من خلال التطبيق.',
    },
    {
      'image': MyAssetsImage.citio15,
      'title': 'تواصل مع مجتمعك',
      'subtitle':
          'تابع آخر الأخبار، شارك رأيك، وكن جزءًا من الحياة الاجتماعية للمدينة.',
    },
    {
      'image': MyAssetsImage.citio16,
      'title': 'جاهز تبدأ؟',
      'subtitle': 'خلينا نغيّر شكل الحياة في المدينة سوا!',
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () async {
                    await _completeOnboarding();
                  },
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
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
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                pages[index]['image']!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  pages[index]['title']!,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  pages[index]['subtitle']!,
                                  style: TextStyle(
                                    fontSize: 18.sp,
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
              SizedBox(height: 20.h),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
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
              SizedBox(height: 30.h),
              // زر التالي أو تم
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                  vertical: 20.h,
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
                    _currentIndex == pages.length - 1 ? 'تم' : 'التالي',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
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
