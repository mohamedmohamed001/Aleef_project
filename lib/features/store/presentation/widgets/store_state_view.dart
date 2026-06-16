import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

enum StoreStateType { loading, error, empty }

class StoreStateView extends StatelessWidget {
  final StoreStateType type;
  final String? errorMessage;

  const StoreStateView({
    super.key,
    required this.type,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StoreStateType.loading:
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      case StoreStateType.error:
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(
              errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
        );
      case StoreStateType.empty:
        return Center(
          child: Text(
            'No products found',
            style: TextStyle(
              color: Colors.black.withOpacity(0.55),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}
