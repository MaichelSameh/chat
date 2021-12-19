import 'package:flutter/material.dart';

import '../../models/size.dart';
import '../../widgets/widgets.dart';
import 'calls_screen.dart';
import 'contacts_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String route_name = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [
    const MessagesScreen(),
    const ContactsScreen(),
    const CallsScreen(),
    const ProfileScreen(),
  ];

  int currentPageNumber = 0;

  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return Scaffold(
      body: SizedBox(
        height: _size.screenHeight(),
        child: Column(
          children: [
            //the top search bar
            Container(
              height: _size.height(74),
              width: double.infinity,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                ),
              ),
            ),
            //the body of the screen
            Expanded(
                child: PageView(
              controller: pageController,
              physics: const ClampingScrollPhysics(),
              children: pages,
              onPageChanged: (page) {
                currentPageNumber = page;
                setState(() {});
              },
            )),
            BottomNavBar(
              currentPageNumber: currentPageNumber,
              onChange: (_) {
                pageController.animateToPage(
                  _,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
