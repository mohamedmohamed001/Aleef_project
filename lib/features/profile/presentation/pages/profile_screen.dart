import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:aleef/features/pets/presentation/pages/add_pet_screen.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/account_setting_item.dart';
import '../widgets/my_pets_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_options_card.dart';
import '../widgets/profile_stats.dart';
import 'edit_profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  final ScrollController _scrollController = ScrollController();

  Future<void> scrollToTop({bool animated = true}) async {
    if (!_scrollController.hasClients) return;

    if (animated) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfile()),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {});

      await scrollToTop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }

  void _openAddPetForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetScreen(service: PetsService()),
      ),
    );
    if (result != null && mounted) {
      final storage = SecureStorageService();
      String? token = await storage.getToken();
      if (token != null) {
        Provider.of<PetsProvider>(context, listen: false).getAllPets(token);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Using addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = SecureStorageService();
      final String? token = await storage.getToken();

      // Check if the widget is still in the tree and token is not null
      if (mounted && token != null) {
        // Use listen: false because we are outside the build method
        Provider.of<PetsProvider>(context, listen: false).getAllPets(token);
      }

      // Safety check for the scroll controller
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const ProfileHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  const ProfileStats(),
                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      Text(
                        "My Pets",
                        style: AppTextStyles.black16Bold.copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _openAddPetForm,

                        child: Text(
                          "+Add Pet",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  Consumer<PetsProvider>(
                    builder: (context, petsProvider, child) {
                      if (petsProvider.isLoading) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      final petList = petsProvider.allPets;

                      if (petList.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(child: Text("No pets found")),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: petList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final currentPet = petList[index];
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Pet"),
                                  content: const Text(
                                    "Are you sure you want to remove this pet?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final SecureStorage =
                                            SecureStorageService();
                                        String? token =
                                            await SecureStorage.getToken();
                                        if (token != null) {
                                          await petsProvider.deletePet(
                                            currentPet.id,
                                            token,
                                          );
                                        }
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: MyPetsCard(pet: currentPet),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  const ProfileOptionsCard(),

                  SizedBox(height: 24.h),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Account Settings",
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: _openEditProfile,
                    child: const AccountSettingItem(),
                  ),

                  SizedBox(height: 24.h),

                  const Text(
                    "ALEEF v1.0.0 · Pet Healthcare Platform",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
