// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/generated/l10n.dart';
import 'package:citio/screens/all_vendors_screen.dart';
import 'package:citio/screens/my_order_page.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:citio/screens/on_boarding_page.dart';
import 'package:citio/screens/social_media.dart';
import 'package:citio/screens/welcome-page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/government_screen.dart';
import 'screens/service_order_screen.dart';
import 'screens/first_issue_screen.dart';
import 'screens/notifications.dart';
import 'screens/profile.dart';
import 'services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51RLPpD4IqJm5QRclRVNpb2uYfWNndIr4CtugZBrr4nzJaJPiY4K5iQuTC3fPyoeHVikAhxI80eofzfV6a3EbhzJx00MUomlZ1X";
  await Stripe.instance.applySettings();
  await NotificationHelper.initialize();
  await Firebase.initializeApp();
  await FCMService().initFCM();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => CityApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class CityApp extends StatelessWidget {
  final bool seenOnboarding;

  const CityApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 800), // مقاس التصميم الأساسي (زي Pixel 3)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          home: seenOnboarding ? const StartPage() : const SliderScreen(),
          theme: ThemeData(
            hoverColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

// كلاس HomePage زي ما هو، بدون تغيير
class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const GovernmentScreen(),
    const SocialMedia(),
    const ServiceOrderScreen(),
    const Notifications(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          currentIndex == 0
              ? PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: AppBar(
                  //automaticallyImplyLeading: true,
                  centerTitle: true,
                  backgroundColor: MyColors.specialbackground,
                  //foregroundColor: MyColors.specialbackground,
                  surfaceTintColor: MyColors.specialbackground,
                  elevation: 0,
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 16.h, 0.w, 16.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomSearchBar(
                                height: 40.h,
                                borderRadius: 25.r,
                                hintText: 'ماذا تريد',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Notifications(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.notifications_none_outlined,
                                color: MyColors.gray,
                              ),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : null,
      body: pages[currentIndex],
      drawer: Drawer(
        backgroundColor: MyColors.offWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: MyColors.specialbackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مدينتنا',
                    style: TextStyle(
                      color: MyColors.black,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'مرحباً بكم!',
                    style: TextStyle(color: MyColors.black, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الرئيسية'),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_police_rounded),
              title: const Text('حكومتنا'),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('المشاكل'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IssueScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_compact_sharp),
              title: const Text('الخدمات'),
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('وسائل التواصل الاجتماعي'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SocialMedia()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: const Text('البائعين'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllVendorsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('طلباتي'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("token", "");
                await prefs.setString("refreshToken", "");

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyloginPage()),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(size: 30.sp),
        unselectedIconTheme: IconThemeData(size: 25.sp),
        selectedLabelStyle: TextStyle(fontSize: 16.sp),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp),
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyColors.specialbackground,
        selectedItemColor: MyColors.primary,
        unselectedItemColor: MyColors.gray,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home_filled : Icons.home_outlined,
            ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.local_police_rounded
                  : Icons.local_police_outlined,
            ),
            label: 'حكومتنا',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.language : Icons.language_outlined,
            ),
            label: 'المجتمع',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.view_compact_alt
                  : Icons.view_compact_sharp,
            ),
            label: 'الخدمات ',
          ),
        ],
      ),
    );
  }
}
