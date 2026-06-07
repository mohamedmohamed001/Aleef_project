import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.pets_rounded,
      title: 'Everything your pet needs',
      description:
      'Book appointments, shop essentials, and manage care in one place.',
    ),
    _OnboardingItem(
      icon: Icons.health_and_safety_rounded,
      title: 'Smart health records',
      description:
      'Keep vaccinations, medical records, and reminders organized.',
    ),
    _OnboardingItem(
      icon: Icons.chat_bubble_rounded,
      title: 'Chat with care',
      description:
      'Talk to vets or use ALEEF assistant whenever you need help.',
    ),
  ];

  bool get _isLastPage => _currentIndex == _items.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_isLastPage) {
      _goToAuth();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToAuth() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.chooseRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const _SoftBackgroundShapes(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  SizedBox(height: 18.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _AleefLogo(),
                      TextButton(
                        onPressed: _goToAuth,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _items.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final item = _items[index];

                        return _OnboardingPage(
                          item: item,
                          index: index,
                        );
                      },
                    ),
                  ),

                  _BottomFloatingCard(
                    item: _items[_currentIndex],
                    currentIndex: _currentIndex,
                    totalItems: _items.length,
                    isLastPage: _isLastPage,
                    onNext: _goNext,
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingItem item;
  final int index;

  const _OnboardingPage({
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28.h),

        Expanded(
          child: Center(
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 22.h,
                    right: 28.w,
                    child: _MiniBubble(size: 32.w),
                  ),
                  Positioned(
                    bottom: 36.h,
                    left: 22.w,
                    child: _MiniBubble(size: 46.w),
                  ),
                  Positioned(
                    bottom: 18.h,
                    right: 42.w,
                    child: _MiniBubble(size: 18.w),
                  ),
                  Container(
                    width: 148.w,
                    height: 148.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.18),
                          blurRadius: 35,
                          offset: Offset(0, 16.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      size: 70.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 150.h),
      ],
    );
  }
}

class _BottomFloatingCard extends StatelessWidget {
  final _OnboardingItem item;
  final int currentIndex;
  final int totalItems;
  final bool isLastPage;
  final VoidCallback onNext;

  const _BottomFloatingCard({
    required this.item,
    required this.currentIndex,
    required this.totalItems,
    required this.isLastPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: Offset(0, 14.h),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF172625),
              height: 1.15,
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7A78),
              height: 1.55,
            ),
          ),

          SizedBox(height: 22.h),

          _DotsIndicator(
            currentIndex: currentIndex,
            totalItems: totalItems,
          ),

          SizedBox(height: 24.h),

          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: Text(
                isLastPage ? 'Get Started' : 'Next',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalItems;

  const _DotsIndicator({
    required this.currentIndex,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalItems,
            (index) {
          final bool isActive = index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            width: isActive ? 24.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }
}

class _AleefLogo extends StatelessWidget {
  const _AleefLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 22,
            offset: Offset(0, 8.h),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pets_rounded,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'ALEEF',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftBackgroundShapes extends StatelessWidget {
  const _SoftBackgroundShapes();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80.h,
          right: -90.w,
          child: Container(
            width: 230.w,
            height: 230.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.11),
            ),
          ),
        ),
        Positioned(
          top: 110.h,
          left: -70.w,
          child: Container(
            width: 170.w,
            height: 170.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: 130.h,
          right: -45.w,
          child: Container(
            width: 115.w,
            height: 115.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniBubble extends StatelessWidget {
  final double size;

  const _MiniBubble({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.13),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}