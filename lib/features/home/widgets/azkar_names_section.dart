import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/azkar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'azkar_name_card.dart';

class AzkarNamesSection extends StatelessWidget {
  const AzkarNamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "Prayer's Azkar",
                image: AppImages.openHand,
                onTap: () {},
              ),
              AzkarNameCard(
                azkarName: "Morning Azkar",
                icon: Icons.sunny,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const MorningAzkarView();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180.h,
          child: const Row(
            children: [
              AzkarNameCard(
                azkarName: "Sleeping Azkar",
                image: AppImages.sleepMoon,
              ),
              AzkarNameCard(
                azkarName: "Night Azkar",
                image: AppImages.nightMode,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180.h,
          child: const Row(
            children: [
              AzkarNameCard(
                azkarName: "Favourite Azkar",
                image: AppImages.love,
              ),
              AzkarNameCard(
                azkarName: "Your Azkar",
                image: AppImages.rosary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
