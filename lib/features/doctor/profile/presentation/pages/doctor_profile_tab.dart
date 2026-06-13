import 'package:aleef/features/doctor/home/data/models/doctor_profile_model.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_profile_section_button.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_profile_section_card.dart';
import 'package:aleef/features/doctor/profile/presentation/pages/doctor_edit_profile_screen.dart';
import 'package:aleef/features/doctor/profile/presentation/pages/Edit_doctor_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aleef/core/theme/app_colors.dart';

class DoctorProfileTab extends StatefulWidget {
  const DoctorProfileTab({super.key});

  @override
  State<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends State<DoctorProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorProfileProvider>(
        context,
        listen: false,
      ).fetchDoctorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<DoctorProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final doctor = provider.doctorProfile;
          if (doctor == null) {
            return const Center(child: Text("No profile data found."));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderSection(context), // تم تمرير context للرجوع
                // الكارد التي تطفو فوق الجزء الأخضر
                Transform.translate(
                  offset: Offset(0, -60.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildDoctorInfoCard(doctor),
                  ),
                ),

                // باقي الأقسام (تعديل الـ Padding لتعويض الـ Transform)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ).copyWith(top: 40.h),
                  child: Column(
                    children: [
                      DoctorProfileSectionCard(
                        title: 'ABOUT',
                        child: Text(
                          doctor.about.isEmpty
                              ? 'No bio available.'
                              : doctor.about,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                      DoctorProfileSectionCard(
                        title: 'CONTACT INFORMATION',
                        child: Column(
                          children: [
                            _buildContactRow(
                              Icons.phone_outlined,
                              'Phone',
                              doctor.phone,
                            ),
                            SizedBox(height: 12.h),
                            _buildContactRow(
                              Icons.email_outlined,
                              'Email',
                              doctor.email,
                            ),
                          ],
                        ),
                      ),
                      DoctorProfileSectionCard(
                        title: 'CLINIC ADDRESS',
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_hospital_outlined,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                doctor.clinicAddress.isEmpty
                                    ? 'Address not provided'
                                    : doctor.clinicAddress,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      DoctorProfileSectionButton(
                        icon: Icons.calendar_today_outlined,
                        text: 'Edit Schedule',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DoctorEditScheduleScreen(),
                          ),
                        ),
                      ),
                      DoctorProfileSectionButton(
                        icon: Icons.edit_outlined,
                        text: 'Edit Profile',
                        onTap: () async {
                          final isUpdated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DoctorEditProfileScreen(),
                            ),
                          );
                          if (isUpdated == true && context.mounted)
                            provider.fetchDoctorProfile();
                        },
                      ),
                      DoctorProfileSectionButton(
                        icon: Icons.logout,
                        text: 'Logout',
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () => provider.clearProfile(),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
               
                DefaultTabController.of(context).animateTo(0);

                // ملاحظة: إذا كان عندك نظام Navigation آخر للتابات (مثل Provider)،
                // ستحتاجين لاستدعاء دالة التغيير من الـ Provider الخاص بكِ هنا بدلاً من animateTo.
              },
            ),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfoCard(DoctorProfileModel doctor) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44.r,
            backgroundImage: doctor.profilePic != null
                ? NetworkImage(doctor.profilePic!)
                : const AssetImage('assets/images/default_doctor.png')
                      as ImageProvider,
          ),
          SizedBox(height: 12.h),
          Text(
            doctor.name,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            doctor.specialization.isEmpty
                ? 'Veterinarian'
                : doctor.specialization,
            style: TextStyle(color: AppColors.primary),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Text(
                'Dubai',
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
