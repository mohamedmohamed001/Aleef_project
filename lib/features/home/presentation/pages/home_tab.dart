import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/presentation/pages/appointment_details.dart';
import 'package:aleef/features/home/presentation/provider/home_provider.dart';
import 'package:aleef/features/home/presentation/widgets/home_body.dart';
import 'package:aleef/features/home/presentation/widgets/home_products_section.dart';
import 'package:aleef/features/home/presentation/widgets/home_tab_skeleton.dart';
import 'package:aleef/features/home/presentation/widgets/pet_switcher_bottom_sheet.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/pets/presentation/pages/pet_profile_screen.dart';
import 'package:aleef/features/profile/presentation/manager/profile_provider.dart';
import 'package:aleef/features/profile/presentation/pages/profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/details_screen.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initHome();
    });
  }

  Future<void> _initHome() async {
    final homeProvider = context.read<HomeProvider>();

    await homeProvider.initHome(
      userProvider: context.read<UserProvider>(),
      petsProvider: context.read<PetsProvider>(),
      storeProvider: context.read<StoreProvider>(),
      onUnauthorized: _logoutAndGoLogin,
    );
  }

  Future<void> _refreshHome() async {
    final homeProvider = context.read<HomeProvider>();

    await homeProvider.refreshHome(
      userProvider: context.read<UserProvider>(),
      petsProvider: context.read<PetsProvider>(),
      storeProvider: context.read<StoreProvider>(),
      onUnauthorized: _logoutAndGoLogin,
    );
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

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileTab(
          showBackButton: true,
        ),
      ),
    );
  }

  void _openChatBot() {
    Navigator.pushNamed(context, AppRoutes.chatBotScreen);
  }

  void _openAddPet() {
    Navigator.pushNamed(context, AppRoutes.addPet);
  }

  void _openSelectedPetProfile(PetModel? selectedPet) {
    if (selectedPet == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PetProfileScreen(
          pet: selectedPet,
        ),
      ),
    );
  }

  Future<void> _openAppointmentDetails() async {
    final appointmentId = context.read<HomeProvider>().appointment.id;

    if (appointmentId == null || appointmentId.isEmpty) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetails(
          appointmentId: appointmentId,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await context.read<HomeProvider>().fetchCurrentAppointment(
        onUnauthorized: _logoutAndGoLogin,
      );
    }
  }

  void _openProductDetails(HomeProductData product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetails(
          productId: product.id,
        ),
      ),
    );
  }

  void _goToAppointmentsTab() {
    context.read<BottomNavProvider>().changeTab(1);
  }

  void _goToStoreTab() {
    context.read<BottomNavProvider>().changeTab(3);
  }

  void _handlePetCardTap({
    required List<PetModel> pets,
    required PetModel? selectedPet,
  }) {
    if (pets.isEmpty) {
      _openAddPet();
      return;
    }

    if (pets.length == 1) {
      _openSelectedPetProfile(selectedPet);
      return;
    }

    _showPetSwitcherSheet(pets);
  }

  void _showPetSwitcherSheet(List<PetModel> pets) {
    final homeProvider = context.read<HomeProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) {
        return PetSwitcherBottomSheet(
          pets: pets,
          selectedPetIndex: homeProvider.selectedPetIndex,
          onAddPetTap: () {
            Navigator.pop(context);
            _openAddPet();
          },
          onPetSelected: (index, pet) async {
            Navigator.pop(context);

            await context.read<HomeProvider>().fetchSelectedPetDetails(
              index: index,
              pet: pet,
              petsProvider: context.read<PetsProvider>(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final homeProvider = context.watch<HomeProvider>();
    final userProvider = context.watch<UserProvider>();
    final petsProvider = context.watch<PetsProvider>();
    final storeProvider = context.watch<StoreProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final user = userProvider.user ?? homeProvider.session.currentUser;
    final pets = petsProvider.allPets;

    final selectedPet = homeProvider.resolveSelectedPet(
      petsProvider: petsProvider,
    );

    final homeProducts = homeProvider.buildHomeProducts(storeProvider);

    final int petsCount = petsProvider.allPets.length;
    final int userVisits = profileProvider.appointmentsCount;

    final bool hasPets = petsCount > 0;
    final bool showFreeFirstBookingCard = userVisits == 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      body: RefreshIndicator(
        color: AppColors.primary,
        edgeOffset: topPadding,
        displacement: topPadding + 28.h,
        onRefresh: _refreshHome,
        child: homeProvider.isFirstLoading
            ? const HomeTabSkeleton()
            : HomeBody(
          userName: user?.name ?? "Guest",
          profilePic: user?.profilePic,
          selectedPet: selectedPet,
          showFreeFirstBookingCard: showFreeFirstBookingCard,
          hasPetsForFreeBooking: hasPets,
          isAppointmentLoading: homeProvider.isAppointmentLoading,
          appointment: homeProvider.appointment,
          isProductsLoading: storeProvider.isLoading,
          products: homeProducts,
          onProfileTap: _openProfile,
          onPetTap: () {
            _handlePetCardTap(
              pets: pets,
              selectedPet: selectedPet,
            );
          },
          onAddPetTap: _openAddPet,
          onOpenPetTap: () {
            _openSelectedPetProfile(selectedPet);
          },
          onAskAleefTap: _openChatBot,
          onBookAppointmentTap: _goToAppointmentsTab,
          onFreeFirstBookingTap:
          hasPets ? _goToAppointmentsTab : _openAddPet,
          onViewAppointmentDetails: _openAppointmentDetails,
          onViewAllProductsTap: _goToStoreTab,
          onProductTap: _openProductDetails,
        ),
      ),
    );
  }
}