import 'package:flutter/material.dart';

class QuickActionButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final double borderRadius;
  // final EdgeInsetsGeometry padding;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.onPressed,
    this.borderRadius = 28,
    // this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 140),
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
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            // padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isPressed ? 0.10 : 0.14),
                  blurRadius: isPressed ? 10 : 18,
                  offset: Offset(0, isPressed ? 4 : 8),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final iconBoxSize = constraints.maxHeight * 0.32;

                return Stack(
                  children: [
                    Positioned(
                      top: -constraints.maxHeight * 0.12,
                      right: -constraints.maxWidth * 0.10,
                      child: Container(
                        width: constraints.maxWidth * 0.38,
                        height: constraints.maxWidth * 0.38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}