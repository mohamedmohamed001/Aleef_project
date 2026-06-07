import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomCardContainer extends StatelessWidget {
  final String? title;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;

  const CustomCardContainer({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: borderColor ?? const Color(0xFFBFD5CF),
          width: borderWidth ?? 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!.toUpperCase(),
              style: AppTextStyles.label14Medium.copyWith(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
          ],

          child,
        ],
      ),
    );
  }
}