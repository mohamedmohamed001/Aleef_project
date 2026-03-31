import 'package:aleef/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:aleef/features/chat/presentation/pages/chat_tab.dart';
import 'package:aleef/features/home/presentation/pages/home_tab.dart';
import 'package:aleef/features/main_layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:aleef/features/profile/presentation/pages/profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/store_tab.dart';
import 'package:flutter/material.dart';
final GlobalKey<ProfileTabState> _profileTabKey = GlobalKey<ProfileTabState>();
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      HomeTab(),
      const AppointmentsTab(),
      const ChatTab(),
      const StoreTab(),
      const ProfileTab(),
    ];
  }

  void onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: onNavItemTapped,
      ),
    );
  }
}