import 'package:azkar/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoaaImageSection extends StatelessWidget {
  const DoaaImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          AppImages.doaa,
          height: 380.h,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
