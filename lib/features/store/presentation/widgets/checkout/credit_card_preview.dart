import 'dart:math';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardPreview extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final bool showBack;

  const CreditCardPreview({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.showBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 430),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final rotate = Tween<double>(begin: pi, end: 0).animate(animation);

        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isBack = child?.key == const ValueKey("back");
            final angle = isBack ? rotate.value : -rotate.value;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: child,
            );
          },
        );
      },
      child: showBack
          ? _BackCard(
        key: const ValueKey("back"),
        cvv: cvv,
      )
          : _FrontCard(
        key: const ValueKey("front"),
        cardNumber: cardNumber,
        cardHolder: cardHolder,
        expiryDate: expiryDate,
      ),
    );
  }
}

class _FrontCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  const _FrontCard({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Stack(
        children: [
          Positioned(right: -45.w, top: -45.h, child: _circle(135)),
          Positioned(left: -55.w, bottom: -55.h, child: _circle(145)),
          Positioned(right: 18.w, top: 52.h, child: _chip()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _roundIcon(Icons.credit_card_rounded),
                  const Spacer(),
                  Text(
                    "ALEEF CARD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "CARD NUMBER",
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.only(right: 70.w),
                child: Text(
                  cardNumber.trim().isEmpty
                      ? "••••  ••••  ••••  ••••"
                      : cardNumber.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _info(
                      "Card Holder",
                      cardHolder.trim().isEmpty
                          ? "YOUR NAME"
                          : cardHolder.trim().toUpperCase(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _info(
                    "Expires",
                    expiryDate.trim().isEmpty ? "MM/YY" : expiryDate.trim(),
                    alignEnd: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackCard extends StatelessWidget {
  final String cvv;

  const _BackCard({
    super.key,
    required this.cvv,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Stack(
        children: [
          Positioned(right: -45.w, top: -45.h, child: _circle(135)),
          Positioned(left: -55.w, bottom: -55.h, child: _circle(145)),
          Positioned(
            right: 16.w,
            bottom: 12.h,
            child: Icon(
              Icons.pets_rounded,
              color: Colors.white.withOpacity(.12),
              size: 58.sp,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.34),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(height: 13.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 38.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.92),
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                      alignment: Alignment.centerRight,
                      child: Text(
                        cvv.trim().isEmpty ? "•••" : cvv.trim(),
                        style: TextStyle(
                          color: const Color(0xFF152E2C),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 38.h,
                    width: 52.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(.14)),
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      color: Colors.white.withOpacity(.88),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                "CVV SECURITY CODE",
                style: TextStyle(
                  color: Colors.white.withOpacity(.62),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.white.withOpacity(.10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white.withOpacity(.86),
                      size: 15.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Protected Payment",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.86),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            const Color(0xFF164844),
            const Color(0xFF0C2523),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.24),
            blurRadius: 22.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

Widget _circle(double size) {
  return Container(
    height: size.h,
    width: size.w,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.07),
      shape: BoxShape.circle,
    ),
  );
}

Widget _roundIcon(IconData icon) {
  return Container(
    height: 34.h,
    width: 34.w,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.16),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: Colors.white, size: 19.sp),
  );
}

Widget _chip() {
  return Container(
    height: 30.h,
    width: 46.w,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.16),
      borderRadius: BorderRadius.circular(9.r),
      border: Border.all(color: Colors.white.withOpacity(.14)),
    ),
    child: Icon(
      Icons.memory_rounded,
      color: Colors.white.withOpacity(.85),
      size: 18.sp,
    ),
  );
}

Widget _info(String title, String value, {bool alignEnd = false}) {
  return Column(
    crossAxisAlignment:
    alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(.55),
          fontSize: 8.5.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withOpacity(.92),
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}