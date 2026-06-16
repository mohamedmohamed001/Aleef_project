import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../../../../core/theme/app_colors.dart';

class BookingSuccessView extends StatefulWidget {
  const BookingSuccessView({super.key});

  @override
  State<BookingSuccessView> createState() => _BookingSuccessViewState();
}

class _BookingSuccessViewState extends State<BookingSuccessView>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToAppointments() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.mainLayout,
          (route) => false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavProvider>().changeTab(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary.withOpacity(.18),
              const Color(0xffF8FFFD),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 35.h,
                right: -35.w,
                child: _Circle(size: 120.w, opacity: .12),
              ),
              Positioned(
                top: 145.h,
                left: -45.w,
                child: _Circle(size: 95.w, opacity: .08),
              ),
              Positioned(
                bottom: 80.h,
                right: 24.w,
                child: _Circle(size: 55.w, opacity: .10),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _entryController,
                        curve: Curves.elasticOut,
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 170.w + (_pulseController.value * 12),
                            height: 170.w + (_pulseController.value * 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary.withOpacity(.08),
                            ),
                            child: Center(child: child),
                          );
                        },
                        child: Container(
                          width: 122.w,
                          height: 122.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primary,
                                primary.withOpacity(.75),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(.35),
                                blurRadius: 35,
                                offset: Offset(0, 16.h),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 72.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 35.h),

                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entryController,
                        curve: const Interval(.25, 1),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, .25),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _entryController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(22.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.92),
                            borderRadius: BorderRadius.circular(28.r),
                            border: Border.all(
                              color: primary.withOpacity(.10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.06),
                                blurRadius: 28,
                                offset: Offset(0, 14.h),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Text(
                                  "Confirmed Successfully",
                                  style: TextStyle(
                                    color: primary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              SizedBox(height: 18.h),

                              Text(
                                "Appointment Booked!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xff142322),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              Text(
                                "Your pet’s visit is all set.\nYou can view appointment details anytime.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.7,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              SizedBox(height: 26.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: _MiniInfoCard(
                                      icon: Icons.pets_rounded,
                                      title: "Pet Care",
                                      primary: primary,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _MiniInfoCard(
                                      icon: Icons.event_available_rounded,
                                      title: "Scheduled",
                                      primary: primary,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 28.h),

                              SizedBox(
                                width: double.infinity,
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: _goToAppointments,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "View Appointments",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                            ],
                          ),
                        ),
                      ),
                    ),
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

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;

  const _Circle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(opacity),
      ),
    );
  }
}

class _MiniInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color primary;

  const _MiniInfoCard({
    required this.icon,
    required this.title,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: primary.withOpacity(.07),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: primary,
            size: 24.sp,
          ),
          SizedBox(height: 7.h),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xff263836),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}