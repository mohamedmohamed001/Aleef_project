import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/features/appointments/presentation/pages/appointment_details.dart';
import 'package:aleef/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:aleef/features/appointments/presentation/pages/previous_appointment_screen.dart';
import 'package:aleef/features/auth/presentation/pages/choose_role_screen.dart';
import 'package:aleef/features/auth/presentation/pages/register_screen.dart';
import 'package:aleef/features/auth/presentation/pages/verfication_otp_screen.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/store/presentation/pages/details_screen.dart';
import 'package:aleef/features/store/presentation/pages/cart_screen.dart';
import 'package:aleef/features/store/presentation/pages/my_orders_screen.dart';
import 'package:aleef/features/store/presentation/pages/store_tab.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'app_startup_screen.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/ai_assistant/presentation/pages/chatbot_screen.dart';
import 'features/ai_assistant/services/chatbot_provider.dart';
import 'features/appointments/presentation/pages/appointments_screen.dart';
import 'features/appointments/presentation/provider/appointment_provider.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/providers/verify_provider.dart';
import 'features/chat/presentation/pages/chat_details.dart';
import 'features/chat/presentation/provider/chat_provider.dart';
import 'features/home/presentation/pages/home_tab.dart';
import 'features/main_layout/presentation/pages/main_layout.dart';
import 'features/profile/presentation/pages/edit_profile.dart';
import 'features/store/services/store_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PetsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 853),
      minTextAdapt: false,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: ChooseRoleScreen(),
        routes: {
          AppRoutes.register: (context) => RegisterScreen(),
          AppRoutes.login: (context) => LoginScreen(),
          AppRoutes.chooseRoleScreen: (context) => ChooseRoleScreen(),
          AppRoutes.verificationOtp: (context) => VerificationOtpScreen(),
          AppRoutes.home: (context) => HomeTab(),
          AppRoutes.mainLayout: (context) => MainLayout(),
          AppRoutes.editProfile: (context) => EditProfile(),
          AppRoutes.appointments: (context) => AppointmentTab(),
          AppRoutes.chatDetails: (context) => ChatDetails(chatId: ''),
          AppRoutes.chatBotScreen: (context) => ChatbotScreen(),
          AppRoutes.previousAppointmentScreen: (context) =>
              PreviousAppointmentScreen(),
          // 🔥 شغلك أنت
          AppRoutes.detailsProduct: (context) => ProductDetails(productId: ''),
          AppRoutes.appointmentDetails: (context) =>
              AppointmentDetails(appointmentId: ''),
          AppRoutes.bookAppointment: (context) =>
              BookAppointmentScreen(doctorId: ''),

          // 🔥 شغلها
          AppRoutes.cart: (context) => CartScreen(),
          AppRoutes.order: (context) => MyOrdersScreen(),
        },
      ),
    );
  }
}
