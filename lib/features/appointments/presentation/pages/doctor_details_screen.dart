import 'dart:ui';

import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/review_model.dart';
import '../../services/appointment_api.dart';
import 'book_appointment_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  DoctorModel doctor = DoctorModel();
  bool isLoading = true;
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    final response = await AppointmentApi().getDoctorDetails(widget.doctorId);

    if (!mounted) return;

    if (response["status"] == "success") {
      setState(() {
        doctor = DoctorModel.fromJson(response["doctor"]);
        reviews = (response["reviews"] as List? ?? [])
            .map((e) => ReviewModel.fromJson(e))
            .toList();
        isLoading = false;
      });
    } else if (response["status"] == "unauthorized") {
      setState(() => isLoading = false);

      await SecureStorageService().deleteToken();
      await SecureStorageService().deleteUser();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } else {
      setState(() => isLoading = false);
    }
  }

  String get doctorName => doctor.name ?? "Doctor";
  String get specialization => doctor.specialization ?? "Veterinarian";
  String get rating => doctor.rating?.toString() ?? "0.0";
  String get doctorImage => doctor.profilePic ?? "";
  String get location =>
      doctor.location ?? doctor.address ?? doctor.city ?? "Location not available";
  String get fee => "${doctor.appointmentFee ?? 0} EGP";
  String get about =>
      doctor.about ??
          "Experienced veterinarian providing trusted medical care, diagnosis, and treatment for pets.";

  bool get hasImage => doctorImage.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      extendBody: true,
      bottomNavigationBar: isLoading ? null : _bookBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 605.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _blurHeader(),

                      Positioned(
                        left: 0,
                        right: 0,
                        top: 205.h,
                        child: _profileCard(),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _quickInfoRow(),
                    SizedBox(height: 16.h),
                    _aboutCard(),
                    SizedBox(height: 16.h),
                    _clinicDetailsCard(),
                    SizedBox(height: 16.h),
                    _reviewsCard(),
                    SizedBox(height: 165.h),
                  ],
                ),
              ),
            ],
          ),
          _backButton(),
        ],
      ),
    );
  }

  Widget _blurHeader() {
    return SizedBox(
      height: 240.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Image.network(
                      doctorImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _gradientHeader(),
                    ),
                  )
                else
                  _gradientHeader(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.12),
                        AppColors.primary.withOpacity(.70),
                        const Color(0xFFF4F7F8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 88.h,
            left: 28.w,
            right: 28.w,
            child: Column(
              children: [
                Text(
                  "Doctor Profile",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  specialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: AppColors.primary.withOpacity(.25),
                width: 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.18),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: const Color(0xFFEAF5F4),
              backgroundImage: hasImage ? NetworkImage(doctorImage) : null,
              child: !hasImage
                  ? Icon(
                Icons.person_rounded,
                size: 58.sp,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            doctorName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF122C2A),
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              specialization,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              _statBox(Icons.star_rounded, rating, "Rating"),
              SizedBox(width: 10.w),
              _statBox(Icons.reviews_rounded, "${reviews.length}", "Reviews"),
              SizedBox(width: 10.w),
              _statBox(Icons.payments_rounded, "${doctor.appointmentFee ?? 0}", "Fee"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF6FAFA),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE4EEEE)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22.sp),
            SizedBox(height: 7.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF122C2A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickInfoRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _quickCard(
              icon: Icons.location_on_rounded,
              title: "Location",
              value: location,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _quickCard(
              icon: Icons.medical_services_rounded,
              title: "Speciality",
              value: specialization,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE5EEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF122C2A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutCard() {
    return _sectionCard(
      icon: Icons.auto_awesome_rounded,
      title: "About Doctor",
      child: Text(
        about,
        style: TextStyle(
          color: const Color(0xFF526260),
          fontSize: 14.sp,
          height: 1.65,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _clinicDetailsCard() {
    return _sectionCard(
      icon: Icons.local_hospital_rounded,
      title: "Clinic Details",
      child: Column(
        children: [
          _detailRow(Icons.location_on_rounded, "Address", location),
          SizedBox(height: 12.h),
          _detailRow(Icons.payments_rounded, "Appointment Fee", fee),
          SizedBox(height: 12.h),
          _detailRow(Icons.medical_services_rounded, "Specialization", specialization),
        ],
      ),
    );
  }

  Widget _reviewsCard() {
    return _sectionCard(
      icon: Icons.forum_rounded,
      title: "Patient Reviews",
      child: reviews.isEmpty
          ? Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFA),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          "No reviews yet.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : Column(
        children: reviews.map((review) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFA),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFE8EEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.primary.withOpacity(.1),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 19.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        review.user.name ?? "User",
                        style: TextStyle(
                          color: const Color(0xFF122C2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFB800),
                      size: 18.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      review.rate?.toString() ?? "0",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF122C2A),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  review.comment ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF122C2A),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF122C2A),
                    fontSize: 13.sp,
                    height: 1.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 14.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.86),
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(color: Colors.white.withOpacity(.9)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SizedBox(
                height: 56.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookAppointmentScreen(
                          doctorId: widget.doctorId,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                  label: Text(
                    "Book Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 16.w,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100.r),
            onTap: () => Navigator.pop(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.22),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(.42)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            const Color(0xFF51B9B0),
            const Color(0xFFBCEDEA),
          ],
        ),
      ),
    );
  }
}