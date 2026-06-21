import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeTabSkeleton extends StatelessWidget {
  const HomeTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Column(
        children: [
          const _TopSkeleton(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 120),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFA),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 120, height: 18),
                SizedBox(height: 14),

                _QuickActionsSkeleton(),

                SizedBox(height: 22),

                _SkeletonCard(height: 132),

                SizedBox(height: 18),

                _SkeletonCard(height: 92),

                SizedBox(height: 26),

                _SkeletonLine(width: 190, height: 18),
                SizedBox(height: 14),
                _SkeletonCard(height: 120),

                SizedBox(height: 22),

                _SkeletonCard(height: 96),

                SizedBox(height: 26),

                _SkeletonLine(width: 160, height: 18),
                SizedBox(height: 14),
                _ProductsSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopSkeleton extends StatelessWidget {
  const _TopSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        MediaQuery.of(context).padding.top + 18,
        18,
        32,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(34),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SkeletonCircle(size: 48, isLight: true),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: 90, height: 12, isLight: true),
                    SizedBox(height: 8),
                    _SkeletonLine(width: 150, height: 18, isLight: true),
                  ],
                ),
              ),
              _SkeletonCircle(size: 44, isLight: true),
            ],
          ),
          SizedBox(height: 24),
          _SkeletonCard(height: 108, isLight: true),
        ],
      ),
    );
  }
}

class _QuickActionsSkeleton extends StatelessWidget {
  const _QuickActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(child: _SkeletonCard(height: 92)),
            SizedBox(width: 12),
            Expanded(child: _SkeletonCard(height: 92)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _SkeletonCard(height: 92)),
            SizedBox(width: 12),
            Expanded(child: _SkeletonCard(height: 92)),
          ],
        ),
      ],
    );
  }
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) {
          return const SizedBox(
            width: 132,
            child: _SkeletonCard(height: 168),
          );
        },
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;
  final bool isLight;

  const _SkeletonCard({
    required this.height,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withOpacity(0.18)
            : Colors.black.withOpacity(0.055),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;
  final double height;
  final bool isLight;

  const _SkeletonLine({
    required this.width,
    required this.height,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withOpacity(0.22)
            : Colors.black.withOpacity(0.065),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;
  final bool isLight;

  const _SkeletonCircle({
    required this.size,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withOpacity(0.20)
            : Colors.black.withOpacity(0.065),
        shape: BoxShape.circle,
      ),
    );
  }
}