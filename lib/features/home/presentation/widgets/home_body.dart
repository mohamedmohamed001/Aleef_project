import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/home/presentation/widgets/home_content_panel.dart';
import 'package:aleef/features/home/presentation/widgets/home_free_first_booking_card.dart';
import 'package:aleef/features/home/presentation/widgets/home_products_section.dart';
import 'package:aleef/features/home/presentation/widgets/home_today_summary_card.dart';
import 'package:aleef/features/home/presentation/widgets/home_top_section.dart';
import 'package:aleef/features/home/presentation/widgets/home_vet_tip_card.dart';
import 'package:aleef/features/home/presentation/widgets/quick_action_section.dart';
import 'package:aleef/features/home/presentation/widgets/upcoming_appointment_section.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBody extends StatelessWidget {
  final String userName;
  final String? profilePic;
  final PetModel? selectedPet;

  final bool showFreeFirstBookingCard;
  final bool hasPetsForFreeBooking;

  final bool isAppointmentLoading;
  final AppointmentModel appointment;

  final bool isProductsLoading;
  final List<HomeProductData> products;

  final VoidCallback onProfileTap;
  final VoidCallback onPetTap;
  final VoidCallback onAddPetTap;
  final VoidCallback onOpenPetTap;
  final VoidCallback onAskAleefTap;
  final VoidCallback onBookAppointmentTap;
  final VoidCallback onFreeFirstBookingTap;
  final VoidCallback onViewAppointmentDetails;
  final VoidCallback onViewAllProductsTap;
  final void Function(HomeProductData product) onProductTap;

  const HomeBody({
    super.key,
    required this.userName,
    required this.profilePic,
    required this.selectedPet,
    required this.showFreeFirstBookingCard,
    required this.hasPetsForFreeBooking,
    required this.isAppointmentLoading,
    required this.appointment,
    required this.isProductsLoading,
    required this.products,
    required this.onProfileTap,
    required this.onPetTap,
    required this.onAddPetTap,
    required this.onOpenPetTap,
    required this.onAskAleefTap,
    required this.onBookAppointmentTap,
    required this.onFreeFirstBookingTap,
    required this.onViewAppointmentDetails,
    required this.onViewAllProductsTap,
    required this.onProductTap,
  });

  bool get hasPet => selectedPet != null;

  bool get hasAppointment => appointment.doctor?.id != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Column(
        children: [
          HomeTopSection(
            userName: userName,
            profilePic: profilePic,
            selectedPet: selectedPet,
            onPetTap: onPetTap,
            onAddPetTap: onAddPetTap,
            onProfileTap: onProfileTap,
          ),
          HomeContentPanel(
            child: hasPet
                ? _PetHomeContent(
              selectedPet: selectedPet!,
              showFreeFirstBookingCard: showFreeFirstBookingCard,
              hasPetsForFreeBooking: hasPetsForFreeBooking,
              isAppointmentLoading: isAppointmentLoading,
              appointment: appointment,
              hasAppointment: hasAppointment,
              isProductsLoading: isProductsLoading,
              products: products,
              onOpenPetTap: onOpenPetTap,
              onAddPetTap: onAddPetTap,
              onAskAleefTap: onAskAleefTap,
              onBookAppointmentTap: onBookAppointmentTap,
              onFreeFirstBookingTap: onFreeFirstBookingTap,
              onViewAppointmentDetails: onViewAppointmentDetails,
              onViewAllProductsTap: onViewAllProductsTap,
              onProductTap: onProductTap,
            )
                : _NoPetHomeContent(
              showFreeFirstBookingCard: showFreeFirstBookingCard,
              hasPetsForFreeBooking: hasPetsForFreeBooking,
              isProductsLoading: isProductsLoading,
              products: products,
              onAddPetTap: onAddPetTap,
              onAskAleefTap: onAskAleefTap,
              onBookAppointmentTap: onBookAppointmentTap,
              onFreeFirstBookingTap: onFreeFirstBookingTap,
              onViewAllProductsTap: onViewAllProductsTap,
              onProductTap: onProductTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetHomeContent extends StatelessWidget {
  final PetModel selectedPet;

  final bool showFreeFirstBookingCard;
  final bool hasPetsForFreeBooking;

  final bool isAppointmentLoading;
  final bool hasAppointment;
  final AppointmentModel appointment;

  final bool isProductsLoading;
  final List<HomeProductData> products;

  final VoidCallback onOpenPetTap;
  final VoidCallback onAddPetTap;
  final VoidCallback onAskAleefTap;
  final VoidCallback onBookAppointmentTap;
  final VoidCallback onFreeFirstBookingTap;
  final VoidCallback onViewAppointmentDetails;
  final VoidCallback onViewAllProductsTap;
  final void Function(HomeProductData product) onProductTap;

  const _PetHomeContent({
    required this.selectedPet,
    required this.showFreeFirstBookingCard,
    required this.hasPetsForFreeBooking,
    required this.isAppointmentLoading,
    required this.hasAppointment,
    required this.appointment,
    required this.isProductsLoading,
    required this.products,
    required this.onOpenPetTap,
    required this.onAddPetTap,
    required this.onAskAleefTap,
    required this.onBookAppointmentTap,
    required this.onFreeFirstBookingTap,
    required this.onViewAppointmentDetails,
    required this.onViewAllProductsTap,
    required this.onProductTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasAppointment || isAppointmentLoading) ...[
          _AppointmentSection(
            isLoading: isAppointmentLoading,
            appointment: appointment,
            onBookTap: onBookAppointmentTap,
            onViewDetails: onViewAppointmentDetails,
          ),
          SizedBox(height: 14.h),
        ],

        _QuickCareSection(
          hasPet: true,
          onAddPetTap: onAddPetTap,
          onOpenPetTap: onOpenPetTap,
          onBookTap: onBookAppointmentTap,
          onAskTap: onAskAleefTap,
          onShopTap: onViewAllProductsTap,
        ),

        SizedBox(height: 16.h),

        HomeTodaySummaryCard(
          pet: selectedPet,
          appointment: appointment,
          onBookTap: onBookAppointmentTap,
          onOpenPetTap: onOpenPetTap,
          onViewAppointmentTap: onViewAppointmentDetails,
        ),

        if (showFreeFirstBookingCard) ...[
          SizedBox(height: 16.h),
          HomeFreeFirstBookingCard(
            hasPets: hasPetsForFreeBooking,
            onTap: onFreeFirstBookingTap,
          ),
        ],

        SizedBox(height: 18.h),

        HomeVetTipCard(
          selectedPet: selectedPet,
        ),

        SizedBox(height: 22.h),

        _StoreSection(
          selectedPet: selectedPet,
          isLoading: isProductsLoading,
          products: products,
          onViewAllTap: onViewAllProductsTap,
          onProductTap: onProductTap,
        ),

        SizedBox(height: 145.h),
      ],
    );
  }}

class _NoPetHomeContent extends StatelessWidget {
  final bool showFreeFirstBookingCard;
  final bool hasPetsForFreeBooking;

  final bool isProductsLoading;
  final List<HomeProductData> products;

  final VoidCallback onAddPetTap;
  final VoidCallback onAskAleefTap;
  final VoidCallback onBookAppointmentTap;
  final VoidCallback onFreeFirstBookingTap;
  final VoidCallback onViewAllProductsTap;
  final void Function(HomeProductData product) onProductTap;

  const _NoPetHomeContent({
    required this.showFreeFirstBookingCard,
    required this.hasPetsForFreeBooking,
    required this.isProductsLoading,
    required this.products,
    required this.onAddPetTap,
    required this.onAskAleefTap,
    required this.onBookAppointmentTap,
    required this.onFreeFirstBookingTap,
    required this.onViewAllProductsTap,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showFreeFirstBookingCard) ...[
          HomeFreeFirstBookingCard(
            hasPets: hasPetsForFreeBooking,
            onTap: onFreeFirstBookingTap,
          ),
          SizedBox(height: 18.h),
        ],

        _QuickCareSection(
          hasPet: false,
          onAddPetTap: onAddPetTap,
          onOpenPetTap: onAddPetTap,
          onBookTap: onBookAppointmentTap,
          onAskTap: onAskAleefTap,
          onShopTap: onViewAllProductsTap,
        ),

        SizedBox(height: 22.h),

        const HomeVetTipCard(),

        SizedBox(height: 26.h),

        _StoreSection(
          selectedPet: null,
          isLoading: isProductsLoading,
          products: products,
          onViewAllTap: onViewAllProductsTap,
          onProductTap: onProductTap,
        ),

        SizedBox(height: 180.h),
      ],
    );
  }
}

class _QuickCareSection extends StatelessWidget {
  final bool hasPet;
  final VoidCallback onAddPetTap;
  final VoidCallback onOpenPetTap;
  final VoidCallback onBookTap;
  final VoidCallback onAskTap;
  final VoidCallback onShopTap;

  const _QuickCareSection({
    required this.hasPet,
    required this.onAddPetTap,
    required this.onOpenPetTap,
    required this.onBookTap,
    required this.onAskTap,
    required this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionsSection(
      hasPet: hasPet,
      onAddPetTap: onAddPetTap,
      onOpenPetTap: onOpenPetTap,
      onBookTap: onBookTap,
      onAskTap: onAskTap,
      onShopTap: onShopTap,
    );
  }
}

class _AppointmentSection extends StatelessWidget {
  final bool isLoading;
  final AppointmentModel appointment;
  final VoidCallback onBookTap;
  final VoidCallback onViewDetails;

  const _AppointmentSection({
    required this.isLoading,
    required this.appointment,
    required this.onBookTap,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return UpcomingAppointmentSection(
      isLoading: isLoading,
      appointment: appointment,
      onBookTap: onBookTap,
      onViewDetails: onViewDetails,
    );
  }
}

class _StoreSection extends StatelessWidget {
  final PetModel? selectedPet;
  final bool isLoading;
  final List<HomeProductData> products;
  final VoidCallback onViewAllTap;
  final void Function(HomeProductData product) onProductTap;

  const _StoreSection({
    required this.selectedPet,
    required this.isLoading,
    required this.products,
    required this.onViewAllTap,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return HomeProductsSection(
      title: selectedPet != null
          ? "Picked for ${selectedPet!.name}"
          : "Pet Essentials",
      subtitle: selectedPet != null
          ? "Products your ${selectedPet!.type} may need"
          : "Start with the basics every pet owner may need",
      isLoading: isLoading,
      products: products,
      onViewAllTap: onViewAllTap,
      onProductTap: onProductTap,
    );
  }
}