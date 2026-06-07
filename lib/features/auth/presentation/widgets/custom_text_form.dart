import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatefulWidget {
  final Validator? validator;
  final TextEditingController controller;
  final IconData? iconPrefix;
  final String? labelText;
  final Widget? iconSuffix;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final String? hintText;
  final TextInputType? keyboardType;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool isPassword;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.iconPrefix,
    this.labelText,
    this.iconSuffix,
    this.maxLines = 1,
    this.minLines,
    this.textAlign,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.color,
    this.borderRadius,
    this.isPassword = false,
    this.contentPadding,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  bool get _isMultiline =>
      (widget.maxLines ?? 1) > 1 || (widget.minLines ?? 1) > 1;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isPassword != widget.isPassword) {
      _obscureText = widget.isPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        widget.borderRadius ?? BorderRadius.circular(16.r);

    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.border.withValues(alpha: 0.9),
        width: 1.2.w,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 1.5.w,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.error,
        width: 1.2.w,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: AppColors.error,
        width: 1.5.w,
      ),
    );

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.isPassword ? 1 : widget.minLines,
      obscureText: widget.isPassword ? _obscureText : false,
      textAlign: widget.textAlign ?? TextAlign.start,
      keyboardType: widget.keyboardType ??
          (_isMultiline ? TextInputType.multiline : TextInputType.text),
      textInputAction: widget.textInputAction ??
          (_isMultiline ? TextInputAction.newline : TextInputAction.done),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        filled: widget.color != null,
        fillColor: widget.color,
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.hint,
        ),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.hint,
        ),
        alignLabelWithHint: _isMultiline,
        prefixIcon: widget.iconPrefix != null
            ? Icon(
          widget.iconPrefix,
          size: 22.sp,
        )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.hint,
            size: 22.sp,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.iconSuffix,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: _isMultiline ? 14.h : 12.h,
            ),
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        border: enabledBorder,
        disabledBorder: enabledBorder,
      ),
    );
  }
}
