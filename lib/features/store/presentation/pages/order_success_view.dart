import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../../../../core/theme/app_colors.dart';

class OrderSuccessView extends StatefulWidget {
  const OrderSuccessView({super.key});

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _boxScale;
  late final Animation<double> _fade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _boxScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, .55, curve: Curves.elasticOut),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.35, 1, curve: Curves.easeOut),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, .18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(.35, 1, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToShop() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.mainLayout,
          (route) => false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BottomNavProvider>().changeTab(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xffF7FBFA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _boxScale,
                child: SizedBox(
                  height: 230.h,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 8.h,
                        child: Container(
                          width: 210.w,
                          height: 70.h,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(.13),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ),

                      _PopItem(
                        controller: _controller,
                        intervalStart: .40,
                        top: 8.h,
                        left: 78.w,
                        child: _FloatingProduct(
                          icon: Icons.pets_rounded,
                          primary: primary,
                        ),
                      ),

                      _PopItem(
                        controller: _controller,
                        intervalStart: .48,
                        top: 35.h,
                        right: 58.w,
                        child: _FloatingProduct(
                          icon: Icons.restaurant_rounded,
                          primary: primary,
                        ),
                      ),

                      _PopItem(
                        controller: _controller,
                        intervalStart: .56,
                        top: 55.h,
                        left: 52.w,
                        child: _FloatingProduct(
                          icon: Icons.medication_liquid_rounded,
                          primary: primary,
                        ),
                      ),

                      Positioned(
                        bottom: 36.h,
                        child: _PetBox(primary: primary),
                      ),

                      Positioned(
                        right: 86.w,
                        bottom: 60.h,
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(.18),
                                blurRadius: 16,
                                offset: Offset(0, 8.h),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: primary,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _contentSlide,
                  child: Column(
                    children: [
                      Text(
                        "Your Pet Box Is Ready!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff142322),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        "Your order has been placed successfully.\nWe’re preparing your pet goodies now.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.7,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 24,
                              offset: Offset(0, 12.h),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(.10),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: primary,
                                size: 25.sp,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                "Aleef is packing your order with care.",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff263836),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _goToShop,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          child: Text(
                            "Continue Shopping",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetBox extends StatelessWidget {
  final Color primary;

  const _PetBox({required this.primary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190.w,
      height: 125.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 18.w,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 78.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: primary.withOpacity(.45),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 18.w,
            child: Transform.rotate(
              angle: 0.35,
              child: Container(
                width: 78.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: primary.withOpacity(.35),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 170.w,
              height: 95.h,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(.28),
                    blurRadius: 26,
                    offset: Offset(0, 14.h),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.pets_rounded,
                  size: 44.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingProduct extends StatelessWidget {
  final IconData icon;
  final Color primary;

  const _FloatingProduct({
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.w,
      height: 54.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: primary,
        size: 27.sp,
      ),
    );
  }
}

class _PopItem extends StatelessWidget {
  final AnimationController controller;
  final double intervalStart;
  final Widget child;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const _PopItem({
    required this.controller,
    required this.intervalStart,
    required this.child,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        intervalStart,
        1,
        curve: Curves.elasticOut,
      ),
    );

    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ScaleTransition(
        scale: animation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}