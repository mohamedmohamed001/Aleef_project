import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:aleef/features/appointments/presentation/pages/previous_appointment_screen.dart';
import 'package:aleef/features/auth/presentation/pages/choose_role_screen.dart';
import 'package:aleef/features/auth/presentation/pages/doctor_register_screen.dart';
import 'package:aleef/features/auth/presentation/pages/register_screen.dart';
import 'package:aleef/features/auth/presentation/pages/verfication_otp_screen.dart';
import 'package:aleef/features/auth/presentation/providers/doctor_register_provider.dart';
import 'package:aleef/features/doctor/home/presentation/manager/appointment_management_provider.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_appointment_provider.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_confirmed_appointments_provider.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/main_layout/doctor_main_layout.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/store/presentation/pages/cart_screen.dart';
import 'package:aleef/features/store/presentation/pages/details_screen.dart';
import 'package:aleef/features/store/presentation/pages/my_orders_screen.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:aleef/providers/doctor_provider.dart';
import 'package:aleef/providers/location_provider.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_startup_screen.dart';
import 'core/services/auth_guard_service.dart';
import 'core/services/service_locator.dart';
import 'core/services/session_service.dart';
import 'core/services/socket_service.dart';
import 'core/theme/app_theme.dart';
import 'features/ai_assistant/presentation/pages/chatbot_screen.dart';
import 'features/ai_assistant/provider/chatbot_provider.dart';
import 'features/appointments/presentation/pages/appointment_details.dart';
import 'features/appointments/presentation/pages/appointments_screen.dart';
import 'features/appointments/presentation/provider/appointment_provider.dart';
import 'features/auth/data/services/doctor_auth_api_service.dart';
import 'features/auth/presentation/pages/doctor_login_screen.dart';
import 'features/auth/presentation/pages/doctor_pending_review_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/user_forget_password_screen.dart';
import 'features/auth/presentation/pages/user_reset_password_screen.dart';
import 'features/auth/presentation/providers/verify_provider.dart';
import 'features/chat/presentation/pages/chat_details.dart';
import 'features/chat/presentation/provider/chat_provider.dart';
import 'features/doctor/Performance/presentation/manager/doctor_performance_provider.dart';
import 'features/doctor/home/presentation/pages/appointment_details_screen.dart';
import 'features/home/presentation/pages/home_tab.dart';
import 'features/home/presentation/provider/home_provider.dart';
import 'features/main_layout/presentation/pages/main_layout.dart';
import 'features/medical_records/presentation/provider/medical_record_details_provider.dart';
import 'features/notifications/pages/notifications_screen.dart';
import 'features/notifications/presentation/provider/notification_provider.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/pets/presentation/pages/add_pet_screen.dart';
import 'features/pets/services/pets_service.dart';
import 'features/profile/presentation/manager/edit_profile_provider.dart';
import 'features/profile/presentation/manager/profile_provider.dart';
import 'features/profile/presentation/pages/edit_profile.dart';
import 'features/profile/presentation/pages/user_change_password_screen.dart';
import 'features/store/services/store_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VerifyProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProfileProvider()),
        ChangeNotifierProvider(create: (_) => PetsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentManagementProvider()),
        ChangeNotifierProvider(
          create: (_) => DoctorConfirmedAppointmentsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SessionService()),
        ChangeNotifierProvider(create: (_) => DoctorAppointmentsProvider()),
        ChangeNotifierProvider(
          create: (_) => DoctorRegisterProvider(DoctorAuthApiService()),
        ),
        ChangeNotifierProvider(create: (_) => DoctorPerformanceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => MedicalRecordDetailsProvider()),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // ← غيرنا من StatelessWidget
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // ← نقلنا الـ helper methods هنا
  String _extractAppointmentId(Object? args) {
    if (args is String) return args;
    if (args is Map) return args['appointmentId'] as String? ?? '';
    return '';
  }

  String _extractProductId(Object? args) {
    if (args is String) return args;
    if (args is Map) return args['productId'] as String? ?? '';
    return '';
  }

  String _extractDoctorId(Object? args) {
    if (args is String) return args;
    if (args is Map) return args['doctorId'] as String? ?? '';
    return '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ← ضفنا
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ← ضفنا
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final socketService = getIt<SocketService>();
      if (!socketService.isConnected) {
        debugPrint('🔄 App resumed — reconnecting socket...');
        socketService.connectCurrentSession();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 853),
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: AuthGuardService.navigatorKey,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AppStartupScreen(),
          routes: {
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.chooseRole: (context) => const ChooseRoleScreen(),
            AppRoutes.verificationOtp: (context) => const VerificationOtpScreen(),
            AppRoutes.home: (context) => const HomeTab(),
            AppRoutes.mainLayout: (context) => const MainLayout(),
            AppRoutes.editProfile: (context) => const EditProfile(),
            AppRoutes.appointments: (context) => const AppointmentTab(),
            AppRoutes.chatDetails: (context) => const ChatDetails(chatId: ''),
            AppRoutes.chatBotScreen: (context) => const ChatbotScreen(),
            AppRoutes.previousAppointmentScreen: (context) =>
            const PreviousAppointmentScreen(),
            AppRoutes.notifications: (context) => const NotificationsScreen(),

            // User Password
            AppRoutes.userChangePassword: (context) =>
            const UserChangePasswordScreen(),

            AppRoutes.userForgetPassword: (context) =>
            const UserForgetPasswordScreen(),

            AppRoutes.userResetPassword: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final email = args is String ? args : '';

              return UserResetPasswordScreen(
                email: email,
              );
            },

            // Doctor
            AppRoutes.doctorLogin: (context) => const DoctorLoginScreen(),
            AppRoutes.doctorRegister: (context) => DoctorRegisterScreen(),
            AppRoutes.doctorPendingReview: (context) =>
            const DoctorPendingReviewScreen(),
            AppRoutes.doctorMainLayout: (context) => const DoctorMainLayout(),

            // Pets
            AppRoutes.addPet: (context) => AddPetScreen(service: PetsService()),

            // Store
            AppRoutes.detailsProduct: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final productId = _extractProductId(args);

              return ProductDetails(productId: productId);
            },
            AppRoutes.cart: (context) => const CartScreen(),
            AppRoutes.order: (context) => const MyOrdersScreen(),

            // User Appointment Details
            AppRoutes.appointmentUserDetails: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final appointmentId = _extractAppointmentId(args);

              return AppointmentDetails(appointmentId: appointmentId);
            },

            // Doctor Appointment Details
            AppRoutes.doctorAppointmentDetails: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final appointmentId = _extractAppointmentId(args);

              bool showActions = true;

              if (args is Map) {
                showActions = args['showActions'] as bool? ?? true;
              }

              return AppointmentDetailsScreen(
                appointmentId: appointmentId,
                showActions: showActions,
              );
            },

            AppRoutes.bookAppointment: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final doctorId = _extractDoctorId(args);

              return BookAppointmentScreen(doctorId: doctorId);
            },

            AppRoutes.onboarding: (context) => const OnboardingScreen(),
          },        );
      },
    );
  }
}
