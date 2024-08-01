import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:flutter/material.dart';
import 'widgets/zekr_card.dart';

class WidgetsWithoutCounter extends StatelessWidget {
  const WidgetsWithoutCounter({super.key, required this.zekrName});
  final String zekrName;
  @override
  Widget build(BuildContext context) {
    late ZekrModel model;
    late int length;
    switch (zekrName) {
      case 'motafareqah':
        length = Azkar().motafareqah.length;
        break;
      case 'roqiah':
        length = Azkar().roqiah.length;
        break;
      case 'fadlElzekr':
        length = Azkar().fadlElzekr.length;
        break;
      case 'fadlEldo3a':
        length = Azkar().fadlEldo3a.length;
        break;
      default:
        length = 0;
    }
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: ListView.builder(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            itemBuilder: (context, index) {
              switch (zekrName) {
                case 'motafareqah':
                  model = Azkar().motafareqah[index];
                  break;
                case 'roqiah':
                  model = Azkar().roqiah[index];
                  break;
                case 'fadlElzekr':
                  model = Azkar().fadlElzekr[index];
                  break;
                case 'fadlEldo3a':
                  model = Azkar().fadlEldo3a[index];
                  break;
              }
              return ZekrCardWidget(
                model: model,
                zekrName: zekrName,
                sort: index + 1,
              );
            },
            itemCount: length,
          ),
        ),
      ),
    );
  }
}
