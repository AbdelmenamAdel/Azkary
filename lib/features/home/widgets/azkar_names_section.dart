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
import 'package:azkar/core/localization/app_localizations.dart';

class AzkarNamesSection extends StatelessWidget {
  const AzkarNamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AzkarNameCard(
                azkarName: context.translate('after_pray_azkar'),
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
                azkarName: context.translate('morning_azkar'),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AzkarNameCard(
                azkarName: context.translate('sleep_azkar'),
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
                azkarName: context.translate('evening_azkar'),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AzkarNameCard(
                azkarName: context.translate('dhikr_virtue'),
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
                azkarName: context.translate('various_azkar'),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AzkarNameCard(
                azkarName: context.translate('allah_names'),
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
                azkarName: context.translate('comprehensive_dua'),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AzkarNameCard(
                azkarName: context.translate('roqiah'),
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
                azkarName: context.translate('daily_werd'),
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
                azkarName: context.translate('friday_sunan'),
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
