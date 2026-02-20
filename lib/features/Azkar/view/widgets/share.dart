import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(Icons.share, color: context.colors.secondary, size: 28),
        ),
      ),
    );
  }
}
