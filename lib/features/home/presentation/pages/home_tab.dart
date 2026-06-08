import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:aleef/core/services/session_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/presentation/pages/appointment_details.dart';
import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:aleef/features/home/presentation/widgets/home_content_panel.dart';
import 'package:aleef/features/home/presentation/widgets/home_products_section.dart';
import 'package:aleef/features/home/presentation/widgets/home_section_title.dart';
import 'package:aleef/features/home/presentation/widgets/home_top_section.dart';
import 'package:aleef/features/home/presentation/widgets/quick_action_section.dart';
import 'package:aleef/features/home/presentation/widgets/upcoming_appointment_section.dart';
import 'package:aleef/features/pets/presentation/pages/pet_profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/details_screen.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pets/presentation/manager/pets_provider.dart';
import '../../../store/services/store_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  AppointmentModel appointment = AppointmentModel();

  final SessionService session = getIt<SessionService>();

  bool isAppointmentLoading = true;

  @override
  void initState() {
    super.initState();
    _initHome();
  }

  Future<void> _initHome() async {
    await _initSession();

    await Future.wait([
      fetchCurrentAppointment(),
      fetchPets(),
      fetchProducts(),
    ]);
  }

  Future<void> _initSession() async {
    final storage = getIt<SecureStorageService>();
    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);

      if (!mounted) return;
      context.read<UserProvider>().setUser(user);
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> fetchPets() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    if (token == null || token.isEmpty) return;
    if (!mounted) return;

    try {
      await context.read<PetsProvider>().getAllPets(token);
    } catch (_) {
      // Prevent home from crashing if pets API fails.
    }
  }

  Future<void> fetchProducts() async {
    if (!mounted) return;

    try {
      await context.read<StoreProvider>().getAllProducts();
    } catch (_) {
      // Prevent home from crashing if products API fails.
    }
  }

  Future<void> fetchCurrentAppointment() async {
    if (!mounted) return;

    setState(() {
      isAppointmentLoading = true;
    });

    try {
      final response = await AppointmentApi().getActiveAppointment();

      debugPrint('Active appointment response: $response');

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          appointment = (response['data'] != null
              ? AppointmentModel.fromJson(
            response['data'] as Map<String, dynamic>,
          )
              : null)!;

          isAppointmentLoading = false;
        });
      } else if (response['status'] == 'unauthorized') {
        await _logoutAndGoLogin();
      } else {
        setState(() {
          appointment = AppointmentModel();
          isAppointmentLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('fetchCurrentAppointment error: $e');
      debugPrint('stack: $stackTrace');

      if (!mounted) return;

      setState(() {
        appointment = AppointmentModel();
        isAppointmentLoading = false;
      });
    }
  }

  Future<void> _logoutAndGoLogin() async {
    final storage = getIt<SecureStorageService>();

    await storage.deleteToken();
    await storage.deleteUser();

    if (!mounted) return;

    context.read<UserProvider>().clearUser();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final user = context.watch<UserProvider>().user ?? session.currentUser;
    final petsProvider = context.watch<PetsProvider>();
    final storeProvider = context.watch<StoreProvider>();

    final selectedPet =
    petsProvider.allPets.isNotEmpty ? petsProvider.allPets.first : null;

    final homeProducts = storeProvider.allProducts.take(5).map((product) {
      return HomeProductData(
        id: product.id,
        name: product.title,
        imageUrl: product.thumbnail.url,
        price: "EGP ${product.finalPrice.toStringAsFixed(0)}",
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      body: RefreshIndicator(
        color: AppColors.primary,
        edgeOffset: topPadding,
        displacement: topPadding + 28,
        onRefresh: _initHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              HomeTopSection(
                userName: user?.name ?? "Guest",
                profilePic: user?.profilePic,
                selectedPet: selectedPet,
                onPetTap: () {
                  if (selectedPet == null) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PetProfileScreen(
                        pet: selectedPet,
                      ),
                    ),
                  );
                },
                onAddPetTap: () {
                  Navigator.pushNamed(context, AppRoutes.addPet);
                },
              ),

              HomeContentPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeSectionTitle(title: "Quick Care"),

                    const SizedBox(height: 14),

                    const QuickActionsSection(),

                    const SizedBox(height: 26),

                    UpcomingAppointmentSection(
                      isLoading: isAppointmentLoading,
                      appointment: appointment,
                      onBookTap: () {
                        context.read<BottomNavProvider>().changeTab(1);
                      },
                      onViewDetails: () {
                        if (appointment.id == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentDetails(
                              appointmentId: appointment.id!,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 26),

                    HomeProductsSection(
                      title: selectedPet != null
                          ? "Picked for ${selectedPet.name}"
                          : "Pet Essentials",
                      subtitle: selectedPet != null
                          ? "Products your ${selectedPet.type} may need"
                          : "Handpicked care products for pets",
                      isLoading: storeProvider.isLoading,
                      products: homeProducts,
                      onViewAllTap: () {
                        context.read<BottomNavProvider>().changeTab(3);
                      },
                      onProductTap: (product) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetails(
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 105),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}