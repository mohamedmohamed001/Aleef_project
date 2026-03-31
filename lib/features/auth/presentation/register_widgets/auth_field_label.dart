import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthFieldLabel extends StatelessWidget {
  final String text;

  const AuthFieldLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}