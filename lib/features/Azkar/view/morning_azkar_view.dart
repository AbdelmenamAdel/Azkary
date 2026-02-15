import 'package:azkar/core/common/custom_appbar.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/zekr_card.dart';

class MorningAzkarView extends StatelessWidget {
  const MorningAzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context, title: "أذكار الصباح"),
          body: BlocBuilder<ZekrCounterCubit, ZekrCounterState>(
            builder: (context, state) {
              var cubit = ZekrCounterCubit.get(context);
              return ListView.builder(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                itemBuilder: (context, index) {
                  return ZekrCardWidget(
                    model: cubit.morning[index],
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
