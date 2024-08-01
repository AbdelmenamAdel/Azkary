import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'widgets/zekr_card.dart';

class MorningAzkarView extends StatelessWidget {
  const MorningAzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: BlocBuilder<ZekrCounterCubit, ZekrCounterState>(
            builder: (context, state) {
              var cubit = ZekrCounterCubit.get(context);
              return ListView.builder(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                itemBuilder: (context, index) {
                  return ZekrCardWidget(
                    data: cubit.morning[index],
                    zekrName: 'morning',
                    sort: index + 1,
                  );
                },
                itemCount: Azkar().morning.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MorningZekrSection extends StatelessWidget {
  const MorningZekrSection({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          (data['title'] == null)
              ? const SizedBox(
                  height: 18,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    data['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: AppColors.secondary,
                    ),
                  ),
                ),
          SizedBox(
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.parent,
              data['zekr'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Nabi",
              ),
            ),
          ),
          (data['leading'] == null)
              ? const SizedBox(
                  height: 18,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 12.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.parent,
                    data['leading'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: AppColors.secondary),
                  ),
                ),
          SizedBox(
            child: CircularStepProgressIndicator(
              totalSteps: data['loop'],
              currentStep: cubit.upMorningLoops[cubit.morning.indexOf(data)],
              stepSize: 10,
              selectedColor: AppColors.blueGrey,
              unselectedColor: AppColors.secondary,
              width: 60,
              height: 60,
              selectedStepSize: 3,
              unselectedStepSize: 1,
              child: Center(
                  child: cubit.downMorningLoops[cubit.morning.indexOf(data)] ==
                          0
                      ? const Icon(
                          Icons.check_rounded,
                          size: 38,
                          color: AppColors.blueGrey,
                        )
                      : Text(
                          cubit.downMorningLoops[cubit.morning.indexOf(data)]
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
