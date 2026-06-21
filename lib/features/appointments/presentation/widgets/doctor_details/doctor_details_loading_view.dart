import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorDetailsLoadingView extends StatelessWidget {
  const DoctorDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
