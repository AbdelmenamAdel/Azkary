import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/view/widgets_without_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoaaImageSection extends StatelessWidget {
  const DoaaImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const WidgetsWithoutCounter(zekrName: "fadlEldo3a");
                },
              ),
            );
          },
          child: Stack(
            children: [
              Image.asset(
                AppImages.doaa,
                height: 350.h,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "فضل الدعاء",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: colors.background,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(AppImages.prayer, height: 150.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
