import 'package:flutter/material.dart';

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
    this.validator, this.keyboardType,
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
        hintText: hintText,
        // alignLabelWithHint: true,
        prefixIcon: Icon(iconPrefix),
        labelText: labelText,
        suffixIcon: iconSuffix != null ? Icon(iconSuffix) : null,
              ),
    );
  }
}
