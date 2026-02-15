import 'package:azkar/core/common/custom_appbar.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/Counter/zekr_counter_state.dart';
import 'widgets/zekr_card.dart';

class AfterPrayAzkarView extends StatelessWidget {
  const AfterPrayAzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context, title: "أذكار بعد الصلاة"),
          backgroundColor: AppColors.primary,
          body: BlocBuilder<ZekrCounterCubit, ZekrCounterState>(
            builder: (context, state) {
              var cubit = ZekrCounterCubit.get(context);
              return ListView.builder(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                itemBuilder: (context, index) {
                  return ZekrCardWidget(
                    model: cubit.afterPray[index],
                    zekrName: 'afterPray',
                    sort: index + 1,
                  );
                },
                itemCount: Azkar().afterPray.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
