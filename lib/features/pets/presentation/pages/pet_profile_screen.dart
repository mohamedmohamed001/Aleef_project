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
  const PetProfileScreen({super.key, required this.pet});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLatestDetails();
    });
  }

  void _fetchLatestDetails() async {
    final petsProvider = Provider.of<PetsProvider>(context, listen: false);
    final secureStorage = SecureStorageService();
    String? token = await secureStorage.getToken();
    if (token != null) {
      petsProvider.fetchPetDetails(widget.pet.id, token);
    } else {
      debugPrint("NO token found in secure storage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetsProvider>(
      builder: (context, petsProvider, child) {
        final currentPet = petsProvider.selectedPet ?? widget.pet;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Pet Profile', style: AppTextStyles.title16SemiBold),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => _navigateToEdit(context, currentPet),
              ),
            ],
          ),
          body: petsProvider.isLoading && petsProvider.selectedPet == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      PetHeaderCard(currentPet: currentPet),
                      SizedBox(height: 25.h),
                      PetInfoSection(currentPet: currentPet),
                      SizedBox(height: 25.h),
                      PetMedicalRecords(
                        records: currentPet.medicalRecords,
                        upcomingVaccinations: currentPet.upcomingVaccinations,
                        completedVaccinations: currentPet.completedVaccinations,
                        overdueVaccinations: currentPet.overdueVaccinations,
                      ),
                      SizedBox(height: 30.h),
                      _buildEditButton(context, currentPet),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _navigateToEdit(BuildContext context, PetModel currentPet) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetProfileScreen(pet: currentPet),
      ),
    );
    _fetchLatestDetails();
  }

  Widget _buildEditButton(BuildContext context, PetModel currentPet) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () => _navigateToEdit(context, currentPet),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: 0,
        ),
        child: Text('Edit Pet Profile', style: AppTextStyles.button16SemiBold),
      ),
    );
  }
}
