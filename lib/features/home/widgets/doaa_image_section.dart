import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/view/widgets_without_counter.dart';
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
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const WidgetsWithoutCounter(
                    zekrName: "fadlEldo3a",
                  );
                },
              ),
            );
          },
          child: Stack(
            children: [
              Image.asset(
                AppImages.doaa,
                height: 380.h,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "فضل الدعاء",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nabi',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  AppImages.prayer,
                  height: 150.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
