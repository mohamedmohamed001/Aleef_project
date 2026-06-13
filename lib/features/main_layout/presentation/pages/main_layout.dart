import 'package:aleef/core/services/socket_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:aleef/features/chat/presentation/pages/chat_tab.dart';
import 'package:aleef/features/home/presentation/pages/home_tab.dart';
import 'package:aleef/features/main_layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:aleef/features/profile/presentation/pages/profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/store_tab.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';

final GlobalKey<ProfileTabState> profileTabKey = GlobalKey<ProfileTabState>();

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SocketService().connectCurrentSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final selectedIndex = bottomNavProvider.selectedIndex;

    final List<Widget> tabs = [
      const HomeTab(),
      const AppointmentTab(),
      const ChatTab(),
      const StoreTab(),
      ProfileTab(key: profileTabKey),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedIndex == 0
          ? null
          : Padding(
        padding: const EdgeInsets.only(bottom: 82),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: AppColors.primary,
          elevation: 6,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.chatBotScreen);
          },
          child: const Icon(
            Icons.smart_toy_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          context.read<BottomNavProvider>().changeTab(index);
        },
      ),
    );
  }
}