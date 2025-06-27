import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/generated/l10n.dart';
import 'package:citio/screens/all_vendors_screen.dart';
import 'package:citio/screens/my_order_page.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:citio/screens/on_boarding_page.dart';
import 'package:citio/screens/social_media.dart';
import 'package:citio/screens/welcome-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/government_screen.dart';
import 'screens/first_issue_screen.dart';
import 'screens/service_order_screen.dart';
import 'screens/notifications.dart';
import 'screens/profile.dart';
import 'services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await Firebase.initializeApp();
  await FCMService().initFCM();
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp((CityApp(seenOnboarding: seenOnboarding)));
}

class CityApp extends StatelessWidget {
  final bool seenOnboarding;

  const CityApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
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
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  //automaticallyImplyLeading: true,
                  centerTitle: true,
                  backgroundColor: MyAppColors.specialbackground,
                  //foregroundColor: MyAppColors.specialbackground,
                  surfaceTintColor: MyAppColors.specialbackground,
                  elevation: 0,
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Expanded(
                              child: CustomSearchBar(
                                height: 40,
                                borderRadius: 25,
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
            const DrawerHeader(
              decoration: BoxDecoration(color: MyAppColors.specialbackground),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مدينتنا',
                    style: TextStyle(
                      color: MyColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'مرحباً بكم!',
                    style: TextStyle(color: MyColors.black, fontSize: 16),
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
                setState(() {
                  currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.online_prediction),
              title: const Text('لطلب الخدمات'),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyloginPage()),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 25),
        selectedLabelStyle: const TextStyle(fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyAppColors.specialbackground,
        selectedItemColor: MyColors.dodgerBlue,
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
              currentIndex == 3 ? Icons.help : Icons.help_outline_outlined,
            ),
            label: 'لطلب خدمات',
          ),
        ],
      ),
    );
  }
}
