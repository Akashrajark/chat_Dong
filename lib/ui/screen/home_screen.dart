import 'package:chat_app/ui/screen/profile_screen.dart';
import 'package:chat_app/ui/screen/signin_screen.dart';
import 'package:chat_app/value/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/custom_icon_textbutton.dart';
import 'message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
    Future.delayed(
      const Duration(microseconds: 100),
      () {
        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (Route<dynamic> route) => true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _tabController.index == 2 ? null : AppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: Colors.blue,
          ),
          const MessageScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Material(
          borderRadius: BorderRadius.circular(40),
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconTextButton(
                  onTap: () {
                    _tabController.animateTo(0);
                  },
                  isActive: _tabController.index == 0,
                  iconData: Icons.call,
                  text: "Calls",
                ),
                CustomIconTextButton(
                  onTap: () {
                    _tabController.animateTo(1);
                  },
                  iconData: Icons.chat_bubble_rounded,
                  text: "Messages",
                  isActive: _tabController.index == 1,
                ),
                CustomIconTextButton(
                  onTap: () {
                    _tabController.animateTo(2);
                  },
                  iconData: Icons.person_rounded,
                  text: "Profile",
                  isActive: _tabController.index == 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
