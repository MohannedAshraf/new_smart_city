import 'package:city/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:city/variables.dart';
import 'package:city/screens/request_screens/request_screen_all.dart';
import 'package:city/screens/request_screens/request_screen_resolved.dart';
import 'package:city/screens/request_screens/request_screen_sent.dart';
import 'package:city/screens/request_screens/request_screen_ur.dart';

class GovernmentScreen extends StatelessWidget {
  const GovernmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const RequestAll(),
      const RequestSent(),
      const RequestUR(),
      const RequestResolved()
    ];
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
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          floatingActionButton: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image Clicked!')));
            },
            child: CircleAvatar(
              radius: 55,
              backgroundColor: theme_color,
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/logo1.png'),
                radius: 50,
              ),
            ),
          ),
          appBar: AppBar(
            //foregroundColor: Colors.amber,
            //shadowColor: theme_color,
            //surfaceTintColor: Colors.black,
            //shadowColor: Colors.amber,
            bottom: TabBar(
              dividerColor: theme_color,
              indicatorColor: theme_color,
              tabAlignment: TabAlignment.center,
              tabs: [
                Card.outlined(
                  color: card_color,
                  child: SizedBox(
                    width: 50,
                    height: 30,
                    child: Center(
                      child: Text(
                        S.of(context).all,
                        style: TextStyle(
                          color: card_font_color,
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Card.outlined(
                  color: card_color,
                  child: SizedBox(
                    width: 55,
                    height: 30,
                    child: Center(
                      child: Text(
                        S.of(context).sent,
                        style: TextStyle(
                          color: card_font_color,
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Card.outlined(
                  color: card_color,
                  // clipBehavior: Clip.hardEdge,

                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: Center(
                      child: Text(
                        S.of(context).underreview,
                        style: TextStyle(
                          color: card_font_color,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Card.outlined(
                  color: card_color,
                  child: SizedBox(
                    width: 55,
                    height: 30,
                    child: Center(
                      child: Text(
                        S.of(context).resolved,
                        style: TextStyle(
                          color: card_font_color,
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 0,
          ),
          body: TabBarView(children: pages),
        ),
      ),
    );
  }
}
