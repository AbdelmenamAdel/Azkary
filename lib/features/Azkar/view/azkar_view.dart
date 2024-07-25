import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
                  // cubit.getCurrentStep(index);
                  return ZekrCardWidget(
                    data: cubit.morning[index],
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

class ZekrCardWidget extends StatelessWidget {
  const ZekrCardWidget({super.key, required this.data, required this.sort});
  final Map<String, dynamic> data;
  final int sort;
  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);

    return InkWell(
      onTap: () {
        cubit.updateCurrentStep(sort - 1);
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(
                    color: AppColors.blueGrey,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(3))),
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
            ZekrSection(
              data: data,
            ),
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

class ZekrSection extends StatelessWidget {
  const ZekrSection({super.key, required this.data});
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
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    data['title'],
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo'),
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
                  child: Text(data['leading']),
                ),
          SizedBox(
            child: CircularStepProgressIndicator(
              totalSteps: data['loop'],
              currentStep: cubit.upLoops[cubit.morning.indexOf(data)],
              stepSize: 10,
              selectedColor: AppColors.blueGrey,
              unselectedColor: AppColors.secondary,
              width: 60,
              height: 60,
              selectedStepSize: 3,
              unselectedStepSize: 1,
              child: Center(
                  child: cubit.downLoops[cubit.morning.indexOf(data)] == 0
                      ? const Icon(
                          Icons.check_rounded,
                          size: 38,
                          color: AppColors.blueGrey,
                        )
                      : Text(
                          cubit.downLoops[cubit.morning.indexOf(data)]
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

class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: InkWell(
        splashColor: Colors.white,
        // highlightColor: Colors.white,
        focusColor: Colors.white,
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.share,
            color: AppColors.blueGrey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
