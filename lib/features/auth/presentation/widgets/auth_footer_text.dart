import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthFooterText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
          ),
          children: [
            TextSpan(text: normalText),
            TextSpan(
              text: actionText,
              style: theme.textTheme.labelMedium!.copyWith(
                fontSize: 14.sp,
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: theme.colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
