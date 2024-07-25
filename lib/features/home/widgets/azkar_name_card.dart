import 'package:azkar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AzkarNameCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      azkarName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                if (icon != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      icon,
                      size: 30,
                    ),
                  ),
                if (image != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      image!,
                      height: 32,
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
