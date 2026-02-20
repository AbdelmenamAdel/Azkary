import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/rosary/electronic_rosary_view.dart';
import 'package:flutter/material.dart';

class ERosarySection extends StatelessWidget {
  const ERosarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ElectronicRosaryView(),
            ),
          );
        },
        child: Container(
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
                // Gradient overlay
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
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Icon/Image
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.secondary!.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.secondary!.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          AppImages.eRosary,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                context.translate('electronic_rosary'),
                                style: TextStyle(
                                  fontSize: 22,

                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  color: colors.text,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                context.translate('tap_to_open_rosary'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  color: colors.text!.withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrow
                      Icon(
                        Icons.arrow_forward_ios,
                        color: colors.secondary,
                        size: 24,
                      ),
                    ],
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
