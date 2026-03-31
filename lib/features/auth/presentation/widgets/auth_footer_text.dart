import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(text: normalText),
            TextSpan(
              text: actionText,
              style: theme.textTheme.labelMedium!.copyWith(
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