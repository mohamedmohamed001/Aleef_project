import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const SectionHeader({super.key, required this.title, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: textStyle),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "See All >",
            style: AppTextStyles.primary12Regular,
          ),
        ),
      ],
    );
  }
}