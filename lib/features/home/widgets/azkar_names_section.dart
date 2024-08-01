import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/view/after_pray_view.dart';
import 'package:azkar/features/Azkar/view/goame3_eldo3a_view.dart';
import 'package:azkar/features/Azkar/view/morning_azkar_view.dart';
import 'package:azkar/features/Azkar/view/widgets_without_counter.dart';
import 'package:azkar/features/Azkar/view/night_azkar_view.dart';
import 'package:azkar/features/Azkar/view/sleeping_view.dart';
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
                onTap: () {
                  ZekrCounterCubit.get(context).fillAfterPrayLoops();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AfterPrayAzkarView();
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: "Morning Azkar",
                icon: Icons.sunny,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        ZekrCounterCubit.get(context).fillMorningLoops();

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
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "Sleeping Azkar",
                image: AppImages.sleepMoon,
                onTap: () {
                  ZekrCounterCubit.get(context).fillSleepingLoops();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const SleepingAzkarView();
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: "Night Azkar",
                image: AppImages.nightMode,
                onTap: () {
                  ZekrCounterCubit.get(context).fillNightLoops();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NightAzkarView();
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
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "Favourite Azkar",
                image: AppImages.love,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WidgetsWithoutCounter(
                          zekrName: "fadlElzekr",
                        );
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: "Your Azkar",
                image: AppImages.rosary,
                onTap: () {
                  ZekrCounterCubit.get(context).fillGoame3Eldo3aLoops();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Goame3Eldo3aView();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
