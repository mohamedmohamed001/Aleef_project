import 'dart:async';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsSection extends StatefulWidget {
  final bool hasPet;
  final VoidCallback onAddPetTap;
  final VoidCallback onOpenPetTap;
  final VoidCallback onBookTap;
  final VoidCallback onAskTap;
  final VoidCallback onShopTap;

  const QuickActionsSection({
    super.key,
    required this.hasPet,
    required this.onAddPetTap,
    required this.onOpenPetTap,
    required this.onBookTap,
    required this.onAskTap,
    required this.onShopTap,
  });

  @override
  State<QuickActionsSection> createState() => _QuickActionsSectionState();
}

class _QuickActionsSectionState extends State<QuickActionsSection> {
  final PageController _controller = PageController();

  int _current = 0;
  Timer? _timer;

  List<_ActionItem> get _actions {
    return [
      _ActionItem(
        eyebrow: 'Book a visit',
        title: 'Find your pet’s doctor',
        subtitle: 'Choose a vet and book in seconds',
        buttonText: 'Book',
        icon: Icons.calendar_month_rounded,
        bgStart: const Color(0xFF0F6B62),
        bgEnd: const Color(0xFF08443F),
        accent: const Color(0xFFFFB76B),
        glow: const Color(0xFF39C6B5),
        onTap: widget.onBookTap,
      ),
      _ActionItem(
        eyebrow: widget.hasPet ? 'Pet profile' : 'First step',
        title: widget.hasPet ? 'Open pet profile' : 'Add your first pet',
        subtitle: widget.hasPet
            ? 'Records, vaccines and visits'
            : 'Create a profile to start care',
        buttonText: widget.hasPet ? 'Open' : 'Add',
        icon: widget.hasPet ? Icons.pets_rounded : Icons.add_rounded,
        bgStart: const Color(0xFF8A4B10),
        bgEnd: const Color(0xFF4A2508),
        accent: const Color(0xFFFFD08A),
        glow: const Color(0xFFFF8A3D),
        onTap: widget.hasPet ? widget.onOpenPetTap : widget.onAddPetTap,
      ),
      _ActionItem(
        eyebrow: 'AI assistant',
        title: 'Ask Aleef anything',
        subtitle: 'Fast answers for pet care',
        buttonText: 'Ask',
        icon: Icons.auto_awesome_rounded,
        bgStart: const Color(0xFF4C3DA6),
        bgEnd: const Color(0xFF251B64),
        accent: const Color(0xFFE2DAFF),
        glow: const Color(0xFF8B7CFF),
        onTap: widget.onAskTap,
      ),
      _ActionItem(
        eyebrow: 'Pet store',
        title: 'Shop essentials',
        subtitle: 'Food, toys and care products',
        buttonText: 'Shop',
        icon: Icons.shopping_bag_rounded,
        bgStart: const Color(0xFF14764C),
        bgEnd: const Color(0xFF083C28),
        accent: const Color(0xFFCFFFF0),
        glow: const Color(0xFF63D693),
        onTap: widget.onShopTap,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (!mounted || !_controller.hasClients) return;

      final actions = _actions;
      if (actions.isEmpty) return;

      final next = (_current + 1) % actions.length;

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 620),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = _actions;

    return SizedBox(
      height: 96.h,
      child: PageView.builder(
        controller: _controller,
        itemCount: actions.length,
        onPageChanged: (i) {
          if (!mounted) return;
          setState(() => _current = i);
        },
        itemBuilder: (_, i) {
          return _BannerSlide(
            item: actions[i],
            currentIndex: _current,
            totalItems: actions.length,
          );
        },
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final _ActionItem item;
  final int currentIndex;
  final int totalItems;

  const _BannerSlide({
    required this.item,
    required this.currentIndex,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              item.bgStart,
              item.bgEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: item.bgEnd.withOpacity(0.18),
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: -34.w,
              top: -44.h,
              child: Container(
                width: 118.w,
                height: 118.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.glow.withOpacity(0.20),
                ),
              ),
            ),

            Positioned(
              right: 42.w,
              bottom: -58.h,
              child: Container(
                width: 104.w,
                height: 104.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.055),
                ),
              ),
            ),

            Positioned(
              left: -28.w,
              bottom: -40.h,
              child: Container(
                width: 82.w,
                height: 82.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.glow.withOpacity(0.09),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              child: Row(
                children: [
                  _ActionIconBox(
                    item: item,
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: _ActionTextContent(
                      item: item,
                    ),
                  ),

                  SizedBox(width: 7.w),

                  _ActionButton(
                    item: item,
                  ),
                ],
              ),
            ),

            Positioned(
              left: 70.w,
              bottom: 9.h,
              child: _SlideIndicator(
                currentIndex: currentIndex,
                totalItems: totalItems,
                color: item.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconBox extends StatelessWidget {
  final _ActionItem item;

  const _ActionIconBox({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 31.w,
            height: 31.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            item.icon,
            color: item.accent,
            size: 21.sp,
          ),
        ],
      ),
    );
  }
}

class _ActionTextContent extends StatelessWidget {
  final _ActionItem item;

  const _ActionTextContent({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: constraints.maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.eyebrow.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.8.sp,
                      fontWeight: FontWeight.w900,
                      color: item.accent.withOpacity(0.78),
                      letterSpacing: 0.65,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.8.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.6.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.70),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final _ActionItem item;

  const _ActionButton({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 6.5.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.buttonText,
            style: TextStyle(
              fontSize: 9.7.sp,
              fontWeight: FontWeight.w900,
              color: item.accent,
              height: 1,
            ),
          ),
          SizedBox(width: 3.w),
          Icon(
            Icons.arrow_forward_rounded,
            size: 12.sp,
            color: item.accent,
          ),
        ],
      ),
    );
  }
}

class _SlideIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalItems;
  final Color color;

  const _SlideIndicator({
    required this.currentIndex,
    required this.totalItems,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalItems, (i) {
        final active = i == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(right: 4.w),
          width: active ? 14.w : 4.5.w,
          height: 4.5.h,
          decoration: BoxDecoration(
            color: active ? color : Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(30.r),
          ),
        );
      }),
    );
  }
}

class _ActionItem {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final Color bgStart;
  final Color bgEnd;
  final Color accent;
  final Color glow;
  final VoidCallback onTap;

  const _ActionItem({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.bgStart,
    required this.bgEnd,
    required this.accent,
    required this.glow,
    required this.onTap,
  });
}