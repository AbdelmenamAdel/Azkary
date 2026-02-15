import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class AzkarNameCard extends StatefulWidget {
  const AzkarNameCard({
    super.key,
    required this.azkarName,
    this.icon,
    this.image,
    this.onTap,
  });
  final String azkarName;
  final IconData? icon;
  final String? image;
  final void Function()? onTap;

  @override
  State<AzkarNameCard> createState() => _AzkarNameCardState();
}

class _AzkarNameCardState extends State<AzkarNameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface!,
                  colors.surface!.withValues(alpha: 0.85),
                ],
              ),
              border: Border.all(
                color: colors.secondary!.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary!.withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: colors.secondary!.withValues(alpha: 0.08),
                  blurRadius: 8,
                  spreadRadius: -1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Subtle gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            colors.secondary!.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with better typography
                        Flexible(
                          child: Text(
                            widget.azkarName,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: colors.text,
                              height: 1.3,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Icon/Image with enhanced styling
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    colors.secondary!.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      colors.secondary!.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: widget.icon != null
                                  ? Icon(
                                      widget.icon,
                                      size: 28,
                                      color: colors.secondary,
                                    )
                                  : widget.image != null
                                      ? Image.asset(
                                          widget.image!,
                                          height: 28,
                                          width: 28,
                                        )
                                      : Icon(
                                          Icons.auto_awesome,
                                          size: 28,
                                          color: colors.secondary,
                                        ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Shimmer effect on press
                  if (_isPressed)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colors.secondary!.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
