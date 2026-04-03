import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final double borderRadius;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.onPressed,
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.12),
          highlightColor: Colors.white.withOpacity(0.06),
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                    padding: const EdgeInsets.all(18),
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
                            icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              title,
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
    );
  }
}