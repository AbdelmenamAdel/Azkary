import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:azkar/features/Azkar/view/widgets/share.dart';
import 'package:flutter/material.dart';

import 'zekr_section.dart';

class ZekrCardWidget extends StatelessWidget {
  const ZekrCardWidget({
    super.key,
    this.model,
    required this.sort,
    required this.zekrName,
  });
  final ZekrModel? model;
  final String zekrName;
  final int sort;
  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);
    final colors = context.colors;

    return InkWell(
      onTap: () {
        switch (zekrName) {
          case 'morning':
            cubit.updateMorningCurrentStep(sort - 1);
            break;
          case 'night':
            cubit.updateNightCurrentStep(sort - 1);
            break;
          case 'afterPray':
            cubit.updateAfterPrayCurrentStep(sort - 1);
            break;
          case 'sleeping':
            cubit.updateSleepingCurrentStep(sort - 1);
            break;
          case 'werdak':
            cubit.updateWerdakCurrentStep(sort - 1);
            break;
          case 'goame3Eldo3a':
            cubit.updateGoame3Eldo3aCurrentStep(sort - 1);
            break;
        }
      },
      child: Card(
        color: colors.surface,
        margin: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Positioned.directional(
              textDirection: Directionality.of(context),
              top: 0,
              end: 0,
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.secondary!,
                      colors.secondary!.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(12),
                    bottomStart: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.secondary!.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$sort",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.surface,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ZekrSection(model: model!, zekrName: zekrName),
            const ShareWidget(),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.mosque_rounded,
                  color: colors.secondary?.withValues(alpha: 0.8),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
