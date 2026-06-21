import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/pets/presentation/pages/edit_pet_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../widgets/pet_details/pet_header_card.dart';
import '../widgets/pet_details/pet_info_section.dart';
import '../widgets/pet_details/pet_medical_records.dart';

class PetProfileScreen extends StatefulWidget {
  final PetModel pet;
  final bool readOnly;

  const PetProfileScreen({
    super.key,
    required this.pet,
    this.readOnly = false,
  });

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.readOnly) return;
      _fetchLatestDetails();
    });
  }

  Future<void> _fetchLatestDetails() async {
    if (widget.readOnly) return;

    final petsProvider = context.read<PetsProvider>();
    final secureStorage = SecureStorageService();

    final token = await secureStorage.getToken();

    if (token == null || token.isEmpty) {
      debugPrint("NO user token found in secure storage");
      return;
    }

    debugPrint("========== PET PROFILE FETCH ==========");
    debugPrint("WIDGET PET ID: ${widget.pet.id}");
    debugPrint("WIDGET PET NAME: ${widget.pet.name}");
    debugPrint("READ ONLY: ${widget.readOnly}");
    debugPrint("=======================================");

    if (widget.pet.id.trim().isEmpty) {
      debugPrint("PET PROFILE ERROR: widget.pet.id is empty");
      await petsProvider.getAllPets(token);
      return;
    }

    await petsProvider.fetchPetDetails(widget.pet.id, token);
  }

  Future<void> _navigateToEdit(BuildContext context, PetModel currentPet) async {
    if (widget.readOnly) return;

    if (currentPet.id.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pet id is missing, please refresh pets and try again"),
        ),
      );

      debugPrint("EDIT NAVIGATION BLOCKED: currentPet.id is empty");
      debugPrint("PET NAME: ${currentPet.name}");
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetProfileScreen(pet: currentPet),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await _fetchLatestDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetsProvider>(
      builder: (context, petsProvider, child) {
        final currentPet = widget.readOnly
            ? widget.pet
            : petsProvider.selectedPet ?? widget.pet;

        final isFirstLoading = widget.readOnly
            ? false
            : petsProvider.isLoading && petsProvider.selectedPet == null;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F8F8),
            elevation: 0,
            centerTitle: true,
            leadingWidth: 58.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            title: Text(
              widget.readOnly ? 'Pet Details' : 'Pet Profile',
              style: AppTextStyles.title16SemiBold.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF101828),
              ),
            ),
            actions: widget.readOnly
                ? []
                : [
              Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: _CircleIconButton(
                  icon: Icons.edit_rounded,
                  onTap: () => _navigateToEdit(context, currentPet),
                ),
              ),
            ],
          ),
          body: isFirstLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
              : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: widget.readOnly
                ? () async {}
                : _fetchLatestDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(
                18.w,
                8.h,
                18.w,
                widget.readOnly ? 28.h : 110.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SoftHeader(readOnly: widget.readOnly),

                  SizedBox(height: 16.h),

                  PetHeaderCard(currentPet: currentPet),

                  SizedBox(height: 20.h),

                  PetInfoSection(currentPet: currentPet),

                  SizedBox(height: 24.h),

                  PetMedicalRecords(
                    records: currentPet.medicalRecords,
                    upcomingVaccinations: currentPet.upcomingVaccinations,
                    completedVaccinations: currentPet.completedVaccinations,
                    overdueVaccinations: currentPet.overdueVaccinations,
                    readOnly: widget.readOnly,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isFirstLoading || widget.readOnly
              ? null
              : SafeArea(
            minimum: EdgeInsets.fromLTRB(18.w, 0, 18.w, 14.h),
            child: SizedBox(
              height: 54.h,
              child: ElevatedButton(
                onPressed: () => _navigateToEdit(context, currentPet),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white,
                      size: 21.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Edit Pet Profile',
                      style: AppTextStyles.button16SemiBold.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SoftHeader extends StatelessWidget {
  final bool readOnly;

  const _SoftHeader({
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18.w,
            top: -22.h,
            child: Container(
              width: 82.r,
              height: 82.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 24.w,
            bottom: -26.h,
            child: Icon(
              Icons.pets_rounded,
              color: Colors.white.withOpacity(0.12),
              size: 68.sp,
            ),
          ),
          Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  readOnly
                      ? Icons.visibility_rounded
                      : Icons.favorite_rounded,
                  color: Colors.white,
                  size: 23.sp,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      readOnly ? "Pet Health Details" : "Health Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      readOnly
                          ? "View pet info, records, and vaccinations"
                          : "Track records, vaccinations, and pet info",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}