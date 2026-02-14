import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/view/after_pray_view.dart';
import 'package:azkar/features/Azkar/view/algmo3ah_view.dart';
import 'package:azkar/features/Azkar/view/allah_names_view.dart';
import 'package:azkar/features/Azkar/view/goame3_eldo3a_view.dart';
import 'package:azkar/features/Azkar/view/morning_azkar_view.dart';
import 'package:azkar/features/Azkar/view/werdak_view.dart';
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
          height: 190.h,
          width: double.infinity,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "أذكار  بعد  الصلاة",
                image: AppImages.pray,
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
                azkarName: "أذكار  الصباح",
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
          height: 190.h,
          width: double.infinity,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "أذكار  النوم",
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
                azkarName: "أذكار  المساء",
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
          height: 190.h,
          width: double.infinity,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "فضل  الذكر",
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
                azkarName: "أذكار  متفرقه",
                image: AppImages.rosary1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WidgetsWithoutCounter(
                          zekrName: "motafareqah",
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190.h,
          width: double.infinity,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "أسماء   الله   الحسني",
                image: AppImages.allah1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AllahNamesView();
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: "جوامع   الدعاء",
                image: AppImages.openHand,
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
        SizedBox(
          height: 350.h,
          width: double.infinity,
          child: Row(
            children: [
              AzkarNameCard(
                azkarName: "الرقية    الشرعية    من    الكتاب    والسنة",
                image: AppImages.quran,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WidgetsWithoutCounter(
                          zekrName: "roqiah",
                        );
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: "وردك  من  الأذكار",
                image: AppImages.sunny,
                onTap: () {
                  ZekrCounterCubit.get(context).fillWerdakLoops();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const WerdakAzkarView();
                      },
                    ),
                  );
                },
              ),
              AzkarNameCard(
                azkarName: " الجمعة  ومحمد  عليه  الصلاة  والسلام",
                image: AppImages.heart,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Algmo3ahView();
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
