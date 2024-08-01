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
                    alignment: Alignment.topRight,
                    child: Text(
                      azkarName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nabi',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                if (icon != null)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      icon,
                      size: 32,
                    ),
                  ),
                if (image != null)
                  Align(
                    alignment: Alignment.bottomLeft,
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
