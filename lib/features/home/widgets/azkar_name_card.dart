import 'package:azkar/core/theme/app_colors_extension.dart';
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
    final colors = context.colors;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          color: colors.surface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      textAlign: TextAlign.start,
                      azkarName,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nabi',
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    )),
                if (icon != null)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Icon(
                      icon,
                      size: 34,
                      color: colors.secondary,
                    ),
                  ),
                if (image != null)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Image.asset(
                      image!,
                      height: 34,
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
