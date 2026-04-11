import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatefulWidget {
  final Validator? validator;
  final TextEditingController controller;
  final IconData? iconPrefix;
  final String? labelText;
  final Widget? iconSuffix;
  final int? maxLines;
  final TextAlign? textAlign;
  final String? hintText;
  final TextInputType? keyboardType;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isPassword;

  const CustomTextFormField({
    super.key,
    required this.controller,

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
    this.isPassword = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obSecureText;

  @override
  void initState() {
    super.initState();
    _obSecureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      // textAlignVertical: TextAlignVertical.top,
      maxLines: widget.maxLines,
      controller: widget.controller,
      // textAlign: TextAlign.start,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obSecureText ?? false,
      textAlign: widget.textAlign ?? TextAlign.start,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        filled: widget.color != null ? true : null,
        fillColor: widget.color,

        hintText: widget.hintText,

        prefixIcon: widget.iconPrefix != null ? Icon(widget.iconPrefix) : null,
        labelText: widget.labelText,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obSecureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.hint ,
          ),
          onPressed: () {
            setState(() {
              _obSecureText = !_obSecureText;
            });
          },
        )
            : widget.iconSuffix,

        enabledBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderRadius: widget.borderRadius!,
                borderSide: const BorderSide(color: AppColors.border, width: 1),
              )
            : null,

        focusedBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderRadius: widget.borderRadius!,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.3,
                ),
              )
            : null,

        errorBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderRadius: widget.borderRadius!,
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              )
            : null,

        focusedErrorBorder: widget.borderRadius != null
            ? OutlineInputBorder(
                borderRadius: widget.borderRadius!,
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
