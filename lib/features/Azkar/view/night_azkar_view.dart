import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'widgets/zekr_card.dart';

class NightAzkarView extends StatelessWidget {
  const NightAzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          backgroundColor: AppColors.primary,
          body: BlocBuilder<ZekrCounterCubit, ZekrCounterState>(
            builder: (context, state) {
              var cubit = ZekrCounterCubit.get(context);
              return ListView.builder(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                itemBuilder: (context, index) {
                  return ZekrCardWidget(
                    model: cubit.night[index],
                    zekrName: 'night',
                    sort: index + 1,
                  );
                },
                itemCount: Azkar().night.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ZekrSection extends StatelessWidget {
  const ZekrSection({
    super.key,
    required this.model,
  });
  final ZekrModel model;

  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);

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
                    model.title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
          SizedBox(
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.parent,
              model.zekr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Nabi",
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
                        color: AppColors.secondary),
                  ),
                ),
          SizedBox(
            child: CircularStepProgressIndicator(
              totalSteps: model.loop!,
              currentStep: cubit.upNightLoops[cubit.night.indexOf(model)],
              stepSize: 10,
              selectedColor: AppColors.blueGrey,
              unselectedColor: AppColors.secondary,
              width: 60,
              height: 60,
              selectedStepSize: 3,
              unselectedStepSize: 1,
              child: Center(
                  child: cubit.downNightLoops[cubit.night.indexOf(model)] == 0
                      ? const Icon(
                          Icons.check_rounded,
                          size: 38,
                          color: AppColors.blueGrey,
                        )
                      : Text(
                          cubit.downNightLoops[cubit.night.indexOf(model)]
                              .toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blueGrey),
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
}
