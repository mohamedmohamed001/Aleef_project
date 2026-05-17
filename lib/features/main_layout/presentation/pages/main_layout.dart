import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:aleef/core/services/socket_service.dart';
import 'package:aleef/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:aleef/features/chat/presentation/pages/chat_tab.dart';
import 'package:aleef/features/home/presentation/pages/home_tab.dart';
import 'package:aleef/features/main_layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:aleef/features/profile/presentation/pages/profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/store_tab.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    final storage = getIt<SecureStorageService>();
    final socketService = getIt<SocketService>();

    final token = await storage.getToken();
    final user = await storage.getUser();

    if (token == null || token.isEmpty || user == null || user.id.isEmpty) {
      print("⚠️ Socket connection skipped: token/user missing");
      return;
    }

    socketService.connect(
      baseUrl: ApiConstant.socketUrl,
      token: token,
      userId: user.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = context.watch<BottomNavProvider>();

    final List<Widget> tabs = [
      const HomeTab(),
      const AppointmentTab(),
      const ChatTab(),
      const StoreTab(),
      ProfileTab(key: profileTabKey),
    ];

    return Scaffold(
      body: IndexedStack(
        index: bottomNavProvider.selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: bottomNavProvider.selectedIndex,
        onItemSelected: (index) {
          context.read<BottomNavProvider>().changeTab(index);
        },
      ),
    );
  }
}
