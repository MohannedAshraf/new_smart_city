// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'core/utils/mycolors.dart';
import 'core/widgets/search_bar.dart';
import 'screens/all_vendors_screen.dart';
import 'screens/government_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_order_page.dart';
import 'screens/mylogin_page.dart';
import 'screens/notifications.dart';
import 'screens/on_boarding_page.dart';
import 'screens/profile.dart';
import 'screens/service_order_screen.dart';
import 'screens/social_media.dart';
import 'screens/socialmedia_initializer_screen.dart';
import 'screens/first_issue_screen.dart';
import 'screens/welcome-page.dart';
import 'services/fcm_service.dart';
import 'services/notification_helper.dart';
import 'generated/l10n.dart';
import 'package:citio/core/utils/project_strings.dart';

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

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int currentIndex;
  bool? isSocialUserInitialized;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    loadSocialUserStatus();
  }

  Future<void> loadSocialUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final initialized = prefs.getBool('isSocialUserInitialized') ?? false;
    if (!mounted) return;
    setState(() {
      isSocialUserInitialized = initialized;
    });
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
    final mq = MediaQuery.of(context);
    return Scaffold(
      appBar:
          currentIndex == 0
              ? PreferredSize(
                preferredSize: Size.fromHeight(mq.size.height * 0.08),
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: MyColors.white,
                  foregroundColor: MyColors.white,
                  surfaceTintColor: MyColors.white,
                  elevation: 0,
                  title: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: mq.size.height * 0.015,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            height: mq.size.height * 0.05,
                            borderRadius: mq.size.height * 0.03,
                            hintText: AppStrings.whatDoYouWant,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Notifications(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none_outlined,
                            color: MyColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : null,
      body: pages[currentIndex],
      drawer: Drawer(
        backgroundColor: MyColors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: MyColors.specialbackground,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icon/citio.svg',
                    height: mq.size.height * 0.135,
                    width: mq.size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    AppStrings.welcome,
                    style: TextStyle(
                      color: MyColors.black,
                      fontSize: mq.size.width * 0.043,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: MyColors.ghostColor,
              thickness: 0.6,
              height: 0,
            ),
            drawerTile(
              icon: Icons.home,
              title: AppStrings.home,
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            drawerTile(
              icon: Icons.local_police_rounded,
              title: AppStrings.government,
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            drawerTile(
              icon: Icons.report,
              title: AppStrings.issues,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IssueScreen()),
                );
              },
            ),
            drawerTile(
              icon: Icons.view_compact_sharp,
              title: AppStrings.services,
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            drawerTile(
              icon: Icons.groups_outlined,
              title: AppStrings.socialMedia,
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                final isInitialized =
                    prefs.getBool('isSocialUserInitialized') ?? false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            isInitialized
                                ? const SocialMedia()
                                : const SocialmediaInitializerScreen(),
                  ),
                );
              },
            ),
            drawerTile(
              icon: Icons.shopping_basket_outlined,
              title: AppStrings.vendors,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllVendorsScreen()),
                );
              },
            ),
            drawerTile(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.myOrders,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
            ),
            drawerTile(
              icon: Icons.person,
              title: AppStrings.profile,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Profile()),
                );
              },
            ),
            drawerTile(
              icon: Icons.logout,
              title: AppStrings.logout,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("token", "");
                await prefs.setString("refreshToken", "");
                await prefs.setBool('isSocialUserInitialized', false);
                SocialMedia.cachedUserMinimal = null;
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyloginPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: MyColors.primary,
        unselectedItemColor: MyColors.gray,
        backgroundColor: MyColors.specialbackground,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(size: mq.size.width * 0.075),
        unselectedIconTheme: IconThemeData(size: mq.size.width * 0.065),
        selectedLabelStyle: TextStyle(fontSize: mq.size.width * 0.04),
        unselectedLabelStyle: TextStyle(fontSize: mq.size.width * 0.035),
        onTap: (index) async {
          if (index == 2) {
            final prefs = await SharedPreferences.getInstance();
            final isInitialized =
                prefs.getBool('isSocialUserInitialized') ?? false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        isInitialized
                            ? const SocialMedia()
                            : const SocialmediaInitializerScreen(),
              ),
            );
          } else {
            setState(() => currentIndex = index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home_filled : Icons.home_outlined,
            ),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.local_police_rounded
                  : Icons.local_police_outlined,
            ),
            label: AppStrings.government,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.language : Icons.language_outlined,
            ),
            label: AppStrings.community,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.view_compact_alt
                  : Icons.view_compact_sharp,
            ),
            label: AppStrings.services,
          ),
        ],
      ),
    );
  }

  Widget drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.whiteSmoke, width: 0.5),
      ),
      child: ListTile(
        iconColor: MyColors.primary,
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
