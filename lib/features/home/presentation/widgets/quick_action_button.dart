import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickActionButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color iconColor;

  final Color? backgroundColor;
  final double borderRadius;
  final double height;
  final EdgeInsetsGeometry padding;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
    required this.iconColor,
    this.backgroundColor,
    this.borderRadius = 24,
    this.height = 110,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onPressed,
          onHighlightChanged: (value) {
            setState(() => isPressed = value);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isPressed ? 0.03 : 0.07),
                  blurRadius: isPressed ? 6 : 12,
                  offset: Offset(0, isPressed ? 2 : 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: isPressed ? 50 : 52,
                  height: isPressed ? 50 : 52,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withOpacity(
                      isPressed ? 0.18 : 0.10,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}