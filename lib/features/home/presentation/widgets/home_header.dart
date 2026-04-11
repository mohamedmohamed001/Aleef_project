import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/widgets/custom_text_form.dart';
import 'notification_button.dart';

class HomeHeader extends StatefulWidget {
  final String? userName;
  final String? profilePic;
  final TextEditingController searchController;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.profilePic,
    required this.searchController,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final firstName =
    (widget.userName != null && widget.userName!.trim().isNotEmpty)
        ? widget.userName!.trim().split(' ').first[0].toUpperCase() +
        widget.userName!.trim().split(' ').first.substring(1)
        : 'Guest';

    final ImageProvider? profileImage =
    (widget.profilePic != null && widget.profilePic!.trim().isNotEmpty)
        ? NetworkImage(widget.profilePic!)
        : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16.w,
        14.h,
        16.w,
        22.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35.h,
            right: -25.w,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: -30.w,
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.white.withOpacity(0.18),
                      backgroundImage: profileImage,
                      child: profileImage == null
                          ? Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26.sp,
                      )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $firstName 👋",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "How is your pet today?",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.82),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const NotificationButton(),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(26.r),
                ),
                child: CustomTextFormField(
                  borderRadius: BorderRadius.circular(24.r),
                  iconPrefix: Icons.search,
                  controller: widget.searchController,
                  hintText: 'Search services, doctors, products...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}