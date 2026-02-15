import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ZekrSection extends StatelessWidget {
  const ZekrSection({
    super.key,
    required this.model,
    required this.zekrName,
  });
  final ZekrModel model;
  final String zekrName;
  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          (model.title == null)
              ? const SizedBox(
                  height: 18,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.parent,
                    model.title!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: colors.secondary,
                    ),
                  ),
                ),
          SizedBox(
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.parent,
              model.zekr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Nabi",
                color: colors.text,
              ),
            ),
          ),
          (model.leading == null)
              ? const SizedBox(
                  height: 18,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 12.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.parent,
                    model.leading!,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: colors.subtext),
                  ),
                ),
          if (model.loop != null)
            SizedBox(
              child: CircularStepProgressIndicator(
                totalSteps: model.loop!,
                currentStep: _up(cubit),
                stepSize: 10,
                selectedColor: colors.primary!,
                unselectedColor: colors.secondary!.withValues(alpha: 0.5),
                width: 60,
                height: 60,
                selectedStepSize: 3,
                unselectedStepSize: 1,
                child: Center(
                    child: _down(cubit) == 0
                        ? Icon(
                            Icons.check_rounded,
                            size: 40,
                            color: colors.secondary,
                          )
                        : Text(
                            _down(cubit).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: colors.text,
                              shadows: [
                                Shadow(
                                  color: colors.primary!.withValues(alpha: 0.3),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          )),
                roundedCap: (_, __) => true,
              ),
            ),
          SizedBox(
            height: 50.h,
          )
        ],
      ),
    );
  }

  int _down(cubit) {
    switch (zekrName) {
      case 'night':
        return cubit.downNightLoops[cubit.night.indexOf(model)];
      case 'morning':
        return cubit.downMorningLoops[cubit.morning.indexOf(model)];
      case 'afterPray':
        return cubit.downAfterPrayLoops[cubit.afterPray.indexOf(model)];
      case 'sleeping':
        return cubit.downSleepingLoops[cubit.sleeping.indexOf(model)];
      case 'goame3Eldo3a':
        return cubit.downGoame3Eldo3aLoops[cubit.goame3Eldo3a.indexOf(model)];
      case 'werdak':
        return cubit.downWerdakLoops[cubit.werdak.indexOf(model)];
      default:
        return 0;
    }
  }

  int _up(cubit) {
    switch (zekrName) {
      case 'night':
        return cubit.upNightLoops[cubit.night.indexOf(model)];
      case 'morning':
        return cubit.upMorningLoops[cubit.morning.indexOf(model)];
      case 'afterPray':
        return cubit.upAfterPrayLoops[cubit.afterPray.indexOf(model)];
      case 'sleeping':
        return cubit.upSleepingLoops[cubit.sleeping.indexOf(model)];
      case 'goame3Eldo3a':
        return cubit.upGoame3Eldo3aLoops[cubit.goame3Eldo3a.indexOf(model)];
      case 'werdak':
        return cubit.upWerdakLoops[cubit.werdak.indexOf(model)];
      default:
        return 0;
    }
  }
}
