import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  final Validator? validator;
  final TextEditingController controller;
  final bool? obSecureText;
  final IconData? iconPrefix;
  final String? labelText;
  final IconData? iconSuffix;
  final int? maxLines;
  final TextAlign? textAlign;
  final String? hintText;
  final TextInputType? keyboardType;
  final Color? color;
  final BorderRadius? borderRadius;

  const CustomTextFormField({
    super.key,
    required this.controller,

    this.obSecureText,
    this.iconPrefix,
    this.labelText,
    this.iconSuffix,
    this.maxLines = 1,

    this.textAlign,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      // textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines,
      controller: controller,
      // textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obSecureText ?? false,
      textAlign: textAlign ?? TextAlign.start,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: color != null ? true : null,
        fillColor: color,

        hintText: hintText,

        prefixIcon: iconPrefix != null ? Icon(iconPrefix) : null,
        labelText: labelText,
        suffixIcon: iconSuffix != null ? Icon(iconSuffix) : null,

        enabledBorder: borderRadius != null
            ? OutlineInputBorder(
                borderRadius: borderRadius!,
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              )
            : null,

        focusedBorder: borderRadius != null
            ? OutlineInputBorder(
                borderRadius: borderRadius!,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.3,
                ),
              )
            : null,

        errorBorder: borderRadius != null
            ? OutlineInputBorder(
                borderRadius: borderRadius!,
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              )
            : null,

        focusedErrorBorder: borderRadius != null
            ? OutlineInputBorder(
                borderRadius: borderRadius!,
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.3,
                ),
              )
            : null,
      ),
    );
  }
}
