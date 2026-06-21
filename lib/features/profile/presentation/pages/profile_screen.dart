import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/account_setting_item.dart';
import '../manager/profile_provider.dart';
import '../widgets/my_pets_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_options_card.dart';
import '../widgets/profile_stats.dart';

class ProfileTab extends StatefulWidget {
  final bool showBackButton;

  const ProfileTab({super.key, this.showBackButton = false});

  @override
  State<ProfileTab> createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  Future<void> scrollToTop({bool animated = true}) async {
    await context.read<ProfileProvider>().scrollToTop(animated: animated);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final profileProvider = context.read<ProfileProvider>();

      await profileProvider.init(context);
      await profileProvider.getAppointmentsAndOrdersCount();
    });
  }

  Future<void> _onRefresh() async {
    final profileProvider = context.read<ProfileProvider>();

    await Future.wait([
      profileProvider.getPets(context),
      profileProvider.getAppointmentsAndOrdersCount(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: profileProvider.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ProfileHeader(
                showBackButton: widget.showBackButton,
                onBackTap: () => Navigator.pop(context),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -24.h),
                      child: Consumer2<PetsProvider, ProfileProvider>(
                        builder: (context, petsProvider, profileProvider, _) {
                          return ProfileStats(
                            petsCount: petsProvider.allPets.length,
                            ordersCount: profileProvider.ordersCount,
                            appointmentsCount:
                                profileProvider.appointmentsCount,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    _SectionHeader(
                      title: "My Pets",
                      actionText: "+ Add Pet",
                      onTap: () {
                        profileProvider.openAddPetForm(context);
                      },
                    ),

                    SizedBox(height: 14.h),

                    Consumer<PetsProvider>(
                      builder: (context, petsProvider, child) {
                        if (petsProvider.isLoading &&
                            petsProvider.allPets.isEmpty) {
                          return const _PetsGridSkeleton();
                        }

                        final petList = petsProvider.allPets;

                        if (petList.isEmpty) {
                          return _EmptyPetsState(
                            onAddPet: () {
                              profileProvider.openAddPetForm(context);
                            },
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: petList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14.h,
                                crossAxisSpacing: 14.w,
                                childAspectRatio: .82,
                              ),
                          itemBuilder: (context, index) {
                            final currentPet = petList[index];

                            return GestureDetector(
                              onLongPress: () {
                                profileProvider.showDeletePetDialog(
                                  context: context,
                                  petId: currentPet.id,
                                  petName: currentPet.name,
                                  petsProvider: petsProvider,
                                );
                              },
                              child: MyPetsCard(pet: currentPet),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 26.h),

                    const ProfileOptionsCard(),

                    SizedBox(height: 26.h),

                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Account Settings",
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    const AccountSettingItem(),

                    SizedBox(height: 24.h),

                    Text(
                      "ALEEF v1.0.0 · Pet Healthcare Platform",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.hint14Regular.copyWith(
                        fontSize: 12.sp,
                        color: Colors.black45,
                      ),
                    ),

                    SizedBox(height: 120.h),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.12)),
            ),
            child: Text(
              actionText,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyPetsState extends StatelessWidget {
  final VoidCallback onAddPet;

  const _EmptyPetsState({required this.onAddPet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 70.r,
            width: 70.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_rounded,
              color: AppColors.primary,
              size: 34.sp,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            "No pets yet",
            style: AppTextStyles.black16Bold.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            "Add your first pet and keep all health details in one place.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body14Regular.copyWith(
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 18.h),
          ElevatedButton.icon(
            onPressed: onAddPet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            icon: Icon(Icons.add_rounded, color: Colors.white, size: 19.sp),
            label: Text(
              "Add Pet",
              style: AppTextStyles.button16SemiBold.copyWith(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetsGridSkeleton extends StatelessWidget {
  const _PetsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 14.w,
        childAspectRatio: .82,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                height: 12.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 10.h,
                width: 110.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
