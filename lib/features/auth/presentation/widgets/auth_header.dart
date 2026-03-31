import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Center(
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "ALEEF",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Pet care made simple",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 36),

        Text(
          title,
          style: const TextStyle(
            fontSize: 24  ,
            fontWeight: FontWeight.w800,
            height: 1.15,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}