import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/pets/presentation/pages/add_pet_screen.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/profile_stats_count_model.dart';
import '../../services/profile_api.dart';

class ProfileProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final ProfileApi _apiService = ProfileApi();

  bool isStatsLoading = false;
  bool isLogoutLoading = false;

  String? statsError;
  String? logoutError;

  int appointmentsCount = 0;
  int ordersCount = 0;

  Future<void> init(BuildContext context) async {
    await getPets(context);

    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  Future<void> scrollToTop({bool animated = true}) async {
    if (!scrollController.hasClients) return;

    if (animated) {
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      scrollController.jumpTo(0);
    }
  }

  Future<void> getPets(BuildContext context) async {
    final storage = SecureStorageService();
    final token = await storage.getToken();

    if (!context.mounted || token == null || token.isEmpty) return;

    await context.read<PetsProvider>().getAllPets(token);
  }

  Future<void> openAddPetForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetScreen(service: PetsService()),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      await getPets(context);
    }
  }

  Future<void> deletePet({
    required BuildContext context,
    required String petId,
    required PetsProvider petsProvider,
  }) async {
    final storage = SecureStorageService();
    final token = await storage.getToken();

    if (token == null || token.isEmpty) return;

    await petsProvider.deletePet(petId, token);
  }

  void showDeletePetDialog({
    required BuildContext context,
    required String petId,
    required String petName,
    required PetsProvider petsProvider,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          title: Text(
            "Delete Pet",
            style: AppTextStyles.black16Bold.copyWith(
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "Are you sure you want to remove $petName?",
            style: AppTextStyles.body14Regular.copyWith(
              height: 1.4,
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  await deletePet(
                    context: context,
                    petId: petId,
                    petsProvider: petsProvider,
                  );
                } catch (_) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Failed to delete pet"),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(12.r),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> getAppointmentsAndOrdersCount() async {
    try {
      isStatsLoading = true;
      statsError = null;
      notifyListeners();

      final ProfileStatsCountModel result =
      await _apiService.getAppointmentsAndOrdersCount();

      appointmentsCount = result.appointments;
      ordersCount = result.orders;
    } catch (e) {
      statsError = e.toString();
    } finally {
      isStatsLoading = false;
      notifyListeners();
    }
  }

  // ================= USER LOGOUT =================

  Future<void> logout(BuildContext context) async {
    if (isLogoutLoading) return;

    try {
      isLogoutLoading = true;
      logoutError = null;
      notifyListeners();

      final storage = SecureStorageService();

      await storage.deleteToken();
      await storage.deleteUser();

      if (!context.mounted) return;

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.login,
            (route) => false,
      );
    } catch (e) {
      logoutError = e.toString().replaceFirst('Exception: ', '');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(logoutError ?? 'Logout failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
    } finally {
      isLogoutLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}