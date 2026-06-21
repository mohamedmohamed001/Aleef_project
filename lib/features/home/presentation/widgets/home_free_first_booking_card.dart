import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeFreeFirstBookingCard extends StatelessWidget {
  final bool hasPets;
  final VoidCallback onTap;

  const HomeFreeFirstBookingCard({
    super.key,
    required this.hasPets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String subtitle = hasPets
        ? "Book your first appointment"
        : "Add your pet to claim it";

    final String buttonText = hasPets ? "Book" : "Add pet";

    const Color ticketDark = Color(0xFF3B2200);
    const Color ticketBrown = Color(0xFF8A4B08);
    const Color ticketOrange = Color(0xFFFF8A3D);
    const Color ticketGold = Color(0xFFFFC857);
    const Color ticketCream = Color(0xFFFFF4D8);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 96.h,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 96.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ticketGold,
                    ticketOrange,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ticketOrange.withOpacity(0.26),
                    blurRadius: 22.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -26.w,
                    top: -34.h,
                    child: Container(
                      width: 96.w,
                      height: 96.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.14),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 92.w,
                    top: 0,
                    bottom: 0,
                    child: _DashedDivider(
                      color: Colors.white.withOpacity(0.34),
                    ),
                  ),

                  Positioned(
                    left: -15.w,
                    top: 33.h,
                    child: _TicketCutout(),
                  ),

                  Positioned(
                    right: -15.w,
                    top: 33.h,
                    child: _TicketCutout(),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        _GoldenGiftIcon(
                          hasPets: hasPets,
                          cream: ticketCream,
                          dark: ticketDark,
                          orange: ticketOrange,
                        ),

                        SizedBox(width: 18.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.22),
                                      borderRadius: BorderRadius.circular(50.r),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                      ),
                                    ),
                                    child: Text(
                                      "GIFT COUPON",
                                      style: TextStyle(
                                        fontSize: 8.2.sp,
                                        fontWeight: FontWeight.w900,
                                        color: ticketDark,
                                        letterSpacing: 0.5,
                                        height: 1,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 6.w),

                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 13.sp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),

                              SizedBox(height: 7.h),

                              Text(
                                "Free first visit",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.5.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.92),
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: ticketCream,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.45),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ticketBrown.withOpacity(0.18),
                                blurRadius: 10.r,
                                offset: Offset(0, 5.h),
                              ),
                            ],
                          ),
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 10.8.sp,
                              fontWeight: FontWeight.w900,
                              color: ticketBrown,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 14.w,
              top: -8.h,
              child: Transform.rotate(
                angle: 0.12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ticketDark,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: ticketDark.withOpacity(0.20),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Text(
                    "FREE",
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoldenGiftIcon extends StatelessWidget {
  final bool hasPets;
  final Color cream;
  final Color dark;
  final Color orange;

  const _GoldenGiftIcon({
    required this.hasPets,
    required this.cream,
    required this.dark,
    required this.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.w,
      height: 62.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.30),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10.h,
            child: Container(
              width: 32.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          Positioned(
            top: 22.h,
            child: Container(
              width: 36.w,
              height: 29.h,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          Positioned(
            top: 22.h,
            child: Container(
              width: 6.w,
              height: 29.h,
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          Positioned(
            top: 31.h,
            child: Container(
              width: 36.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: orange,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          Positioned(
            top: 6.h,
            left: 18.w,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 14.w,
                height: 10.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: cream,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),

          Positioned(
            top: 6.h,
            right: 18.w,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: 14.w,
                height: 10.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: cream,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),

          Positioned(
            right: 6.w,
            bottom: 6.h,
            child: Container(
              width: 19.w,
              height: 19.w,
              decoration: BoxDecoration(
                color: dark,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5.w,
                ),
              ),
              child: Icon(
                hasPets ? Icons.check_rounded : Icons.add_rounded,
                size: 13.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCutout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFA),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        7,
            (index) => Container(
          width: 2.w,
          height: 5.h,
          margin: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}