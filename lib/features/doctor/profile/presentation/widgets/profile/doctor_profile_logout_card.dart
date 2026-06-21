import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProfileLogoutCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const DoctorProfileLogoutCard({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  Future<void> _showLogoutDialog(BuildContext context) async {
    if (isLoading) return;

    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68.r,
                  height: 68.r,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 34.sp,
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2937),
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Are you sure you want to sign out from your doctor account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7B8585),
                    height: 1.45,
                  ),
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4B5563),
                            side: BorderSide(
                              color: const Color(0xFFE5E7EB),
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: isLoading ? null : () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: Colors.red.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Row(
            children: [
              _LogoutIcon(isLoading: isLoading),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading ? 'Logging out...' : 'Logout',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Sign out from doctor account',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.red.withOpacity(0.45),
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutIcon extends StatelessWidget {
  final bool isLoading;

  const _LogoutIcon({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: isLoading
          ? Padding(
        padding: EdgeInsets.all(11.r),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.red,
        ),
      )
          : Icon(
        Icons.logout_rounded,
        color: Colors.red,
        size: 21.sp,
      ),
    );
  }
}