import 'package:azkar/core/utils/app_colors.dart';
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
        }
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: AppColors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                  ),
                ),
                child: Center(
                  child: Text(
                    "$sort",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ZekrSection(model: model!, zekrName: zekrName),
            const ShareWidget(),
            const Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.mosque_rounded,
                  color: AppColors.blueGrey,
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
